#!/bin/bash
#
# Store files from SFTP to storage.
#
# Files must be valid images or videos in the following format: *_YYYYmmdd*
# For example: IMG_20251229_foo_bar.png or Screencast_20251229_1.mp4.
#
# Usage:
#     store

declare -gr SFTP_DIRECTORY="/var/lib/jail/sftp"
declare -gr MEDIA_DIRECTORY="/home/josh/storage/media/photos"
declare -gr RECEIPTS_DIRECTORY="/home/josh/storage/finance/receipts"

main() {
    isEmptyDirectory "${SFTP_DIRECTORY}" && exit 0

    sudo chown josh:josh "${SFTP_DIRECTORY}"/*
    for file in "${SFTP_DIRECTORY}"/*; do
        viewFile "${file}"
        addDescription "${file}"
        moveToStorage "${file}"
    done
}

viewFile() {
    local -r file="${1}"

    if isPhoto "${file}"; then
        imv "${file}" > /dev/null &
    elif isVideo "${file}"; then
        mpv --keep-open=yes "${file}" > /dev/null &
    else
        echoError "Error: Invalid file format. Cannot open: ${file}."
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
    if ! canGetDate "${file}"; then
        echoError "Error: Invalid file name. Cannot move: ${file}."
        return
    fi

    local -r directory="$(getDirectory "${file}")"
    mkdir --parents "${directory}"
    mv "${file}" "${directory}"
}

getDirectory() {
    local -r file="${1}"
    local -r subDirectory="$(getDate "${file}")"

    while ! isYesNoVariableSet "${isReceipt}"; do
        read -rp "Receipt (y/n)? " isReceipt
    done
    if isReceipt "${isReceipt}"; then
        echo "${RECEIPTS_DIRECTORY}/${subDirectory}"
    else
        echo "${MEDIA_DIRECTORY}/${subDirectory}"
    fi
}

getDate() {
    local -r file="${1}"
    name="${file#*_}"  # Remove the first underscore and everything before it.

    # Add a slash between dates to get YYYY/mm/dd format and omit the rest.
    echo "${name:0:4}"/"${name:4:2}"/"${name:6:2}"
}

canGetDate() {
    local -r file="${1}"
    local -r date="$(getDate "${file}")"
    isValidDate "${date}"
}

isValidDate() {
    local -r date="${1}"
    # Check that the date is in YYYY/mm/dd format and is an actual calendar day.
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
    file --brief --mime "$file" | grep --extended-regexp --quiet "video"
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

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
