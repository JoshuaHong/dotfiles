#!/bin/bash
#
# Store files from SFTP to storage.
#
# Usage:
#     store

declare -gr SFTP_DIRECTORY="/var/lib/jail/sftp"
declare -gr MEDIA_DIRECTORY="/home/josh/storage/media/photos"
declare -gr RECEIPTS_DIRECTORY="/home/josh/storage/finance/receipts"

main() {
    sudo chown josh:josh "${SFTP_DIRECTORY}"/*

    for file in "${SFTP_DIRECTORY}"/*; do
        viewFile "${file}" &
        addDescription "${file}"
        moveToStorage "${file}"
    done
}

viewFile() {
    local -r file="${1}"

    if isPhoto "${file}"; then
        imv "${file}" > /dev/null
    elif isVideo "${file}"; then
        mpv --keep-open=yes "${file}" > /dev/null
    else
        echoError "Error: Invalid file: ${file}."
    fi
}

addDescription() {
    local -r file="${1}"

    read -p "Description: " description
    if isVariableSet "${description}"; then
        setfattr --name="user.description" --value="${description}" "${file}"
    fi
}

moveToStorage() {
    local -r file="${1}"
    local -r directory="$(getDirectory "${file}")"

    mkdir --parents "${directory}"
    mv "${file}" "${directory}"
}

getDirectory() {
    local -r file="${1}"
    local -r subDirectory="$(getSubDirectory "${file}")"

    while ! isYesNoVariableSet "${isReceipt}"; do
        read -p "Receipt (y/n)? " isReceipt
    done
    if isReceipt "${isReceipt}"; then
        echo "${RECEIPTS_DIRECTORY}/${subDirectory}"
    else
        echo "${MEDIA_DIRECTORY}/${subDirectory}"
    fi
}

getSubDirectory() {
    local -r file="${1}"

    name="${file#*_}"
    name="${name%%_*}"
    echo "${name:0:4}"/"${name:4:2}"/"${name:6:2}"
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

isYesNoVariableSet() {
    local -r isReceipt="${1}"
    [[ "${isReceipt}" == "y" || "${isReceipt}" == "n" ]]
}

isReceipt() {
    local -r isReceipt="${1}"
    [[ "${isReceipt}" == "y" ]]
}

isVariableSet() {
    local -r variable="${1}"
    [[ -n "${1}" ]]
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
