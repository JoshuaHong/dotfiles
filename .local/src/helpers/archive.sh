#!/bin/bash
#
# Compress and encrypt or decrypt and decompress a file.
#
# Usage:
#     archive file
#
# Arguments:
#     file  - The file to decrypt and decompress if it is properly compressed
#             and encrypted and contains the ".tar.xz.gpg" file extension;
#             the file to compress and encrypt otherwise.

main() {
    local -r file="${1}"

    if ! fileExists "${file}"; then
        echoError "Error: File does not exist."
        exit 1
    fi

    if isCompressedFile "${file}"; then
        extract "${file}"
    else
        archive "${file}"
    fi
}

archive() {
    local -r file="${1}"
    local -r name="${file%/}"  # Remove the trailing slash if it exists.
    local -r password="$(getPassword)"

    cachePassword || exit 1
    tar --create --file="${name}.tar.xz" --xattrs --xattrs-include="*" --xz \
            "${name}"
    gpg --batch --cipher-algo "AES256" --digest-algo "SHA512" \
            --output "${name}.tar.xz.gpg" --passphrase "${password}" --sign \
            --symmetric "${name}.tar.xz"
    rm "${name}.tar.xz"
}

extract() {
    local -r file="${1}"
    local -r name="${file%".tar.xz.gpg"}"  # Remove the file extension.

    gpg --decrypt --output "${name}.tar.xz" "${name}.tar.xz.gpg"
    tar --backup="numbered" --extract --file="${name}.tar.xz" --xattrs \
            --xattrs-include="*" --xz
    rm "${name}.tar.xz"
}

getPassword() {
    local prompt="Enter password: "
    while true; do
        local password="$(enterPassword "${prompt}")"
        local passwordReentry="$(enterPassword "Confirm password: ")"
        [[ "${password}" == "${passwordReentry}" ]] && break
        prompt="Enter password (try again): "
    done

    echo "${password}"
}

enterPassword() {
    local -r prompt="${1}"
    fuzzel --dmenu --prompt="${prompt}" --password --width=40
}

cachePassword() {
    echo | gpg --sign > /dev/null 2>&1
}

fileExists() {
    local -r file="${1}"

    [[ -e "${file}" ]]
}

isCompressedFile() {
    local -r file="${1}"

    [[ "${file}" == *".tar.xz.gpg" ]]
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
