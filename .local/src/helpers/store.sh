#!/bin/bash
#
# Store files from SFTP to storage.
#
# File names must be the following to be sorted by date: /^[^_]*_(yyyyMMdd.*)$/g
# For example, IMG_20251229_foo_bar.png or Screencast_20251229_1.mp4 will be
# stored in the 2025/12/29 directory; otherwise, they will be renamed manually.
#
# Usage:
#     store

declare -gr SFTP_DIRECTORY="/var/lib/jail/sftp"
declare -Agr BASE_DIRECTORIES=(
        ["${HOME}"]=""
        ["/mnt/sda"]="/dev/sda"
        ["/mnt/sdb"]="/dev/sdb")
declare -gr MEDIA_DIRECTORY="storage/media/photos"
declare -gr RECEIPTS_DIRECTORY="storage/finance/receipts"

main() {
    isEmptyDirectory "${SFTP_DIRECTORY}" && exit 0
    sudo chown "${USER}:${USER}" "${SFTP_DIRECTORY}"/* || exit 1
    mountStorageDirectories
    storeFiles
    unmountStorageDirectories
}

mountStorageDirectories() {
    for directory in "${!BASE_DIRECTORIES[@]}"; do
        local device="${BASE_DIRECTORIES["${directory}"]}"
        sudo mkdir --parents "${directory}"
        if isVariableSet "${device}"; then
            sudo mount "${device}" "${directory}" || exit 1
        fi
    done
}

storeFiles() {
    for file in "${SFTP_DIRECTORY}"/*; do
        if ! isRegularFile "${file}"; then
            echoError "Error: Invalid file: ${file}."
            continue
        fi
        viewFile "${file}"
        addDescription "${file}"
        moveToStorage "${file}"
    done
}

unmountStorageDirectories() {
    for directory in "${!BASE_DIRECTORIES[@]}"; do
        local device="${BASE_DIRECTORIES["${directory}"]}"
        if isVariableSet "${device}"; then
            sudo umount "${device}"
        fi
    done
}

viewFile() {
    local -r file="${1}"

    if isPhoto "${file}"; then
        imv "${file}" > /dev/null &
    elif isVideo "${file}"; then
        mpv --keep-open=yes "${file}" > /dev/null &
    elif isPdf "${file}"; then
        zathura "${file}" > /dev/null &
    else
        foot --hold bash -c "cat ${file}" > /dev/null 2>&1 &
    fi
}

addDescription() {
    local -r file="${1}"

    read -rp "Description: " description
    if isVariableSet "${description}"; then
        setfattr --name="user.description" --value="${description}" "${file}"
    fi
}

moveToStorage() {
    local -r file="${1}"
    local -r name="$(renameFile "${file}")"

    local -r isReceipt="$(getIsReceipt)"
    for baseDirectory in "${!BASE_DIRECTORIES[@]}"; do
        local directory="$(getDirectory "${baseDirectory}" "${name}" \
                "${isReceipt}")"
        mkdir --parents "${directory}"
        cp --archive --backup="numbered" "${SFTP_DIRECTORY}/${name}" \
                "${directory}" || exit 1
    done
    rm "${SFTP_DIRECTORY}/${name}"
}

renameFile() {
    local -r file="${1}"
    local -r name="$(basename "${file}")"
    local -r extension="${file#*.}"

    if isValidDate "$(getDate "${name}")"; then
        echo "${name}"
        return
    fi

    while ! isValidDate "${date}"; do
        read -rp "Date (yyyy/MM/dd): " date
    done
    local -r date="${date:0:4}${date:5:2}${date:8:2}"  # Remove the slashes.
    mv --backup="numbered" "${file}" "${SFTP_DIRECTORY}/${date}.${extension}"
    echo "${date}.${extension}"
}

getDirectory() {
    local -r baseDirectory="${1}"
    local -r name="${2}"
    local -r isReceipt="${3}"
    local -r dateDirectory="$(getDate "${name}")"

    if isReceipt "${isReceipt}"; then
        echo "${baseDirectory}/${RECEIPTS_DIRECTORY}/${dateDirectory}"
    else
        echo "${baseDirectory}/${MEDIA_DIRECTORY}/${dateDirectory}"
    fi
}

getIsReceipt() {
    while ! isYesNoVariableSet "${isReceipt}"; do
        read -rp "Receipt (y/n)? " isReceipt
    done
    echo "${isReceipt}"
}

getDate() {
    local name="${1}"
    name="${name#*_}"  # Remove the first underscore and everything before it.
    # Add a slash between dates to get yyyy/MM/dd format and omit the rest.
    echo "${name:0:4}"/"${name:4:2}"/"${name:6:2}"
}

isValidDate() {
    local -r date="${1}"
    # Check that the date is in yyyy/MM/dd format and is an actual calendar day.
    [[ "${date}" =~ ^[0-9]{4}/[0-9]{2}/[0-9]{2}$ ]] && \
            date -d "${date}" "+%Y/%m/%d" > /dev/null 2>&1
}

isPhoto() {
    local -r file="${1}"
    file --brief --mime "${file}" \
            | grep --extended-regexp --quiet 'image|bitmap'
}

isVideo() {
    local -r file="${1}"
    file --brief --mime "${file}" | grep --extended-regexp --quiet "video"
}

isPdf() {
    local -r file="${1}"
    file --brief --mime "${file}" | grep --extended-regexp --quiet "pdf"
}

isReceipt() {
    local -r isReceipt="${1}"
    [[ "${isReceipt}" == "y" ]]
}

isYesNoVariableSet() {
    local -r isReceipt="${1}"
    [[ "${isReceipt}" == "y" || "${isReceipt}" == "n" ]]
}

isVariableSet() {
    local -r variable="${1}"
    [[ -n "${variable}" ]]
}

isEmptyDirectory() {
    local -r directory="${1}"
    [[ -z "$(ls -A "${directory}")" ]]
}

isRegularFile() {
    local -r file="${1}"
    [[ -f "${file}" ]]
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
