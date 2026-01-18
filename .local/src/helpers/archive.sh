#!/bin/bash
#
# Compress and encrypt or decrypt and decompress a file.
#
# Usage:
#     archive [file ...]
#
# Arguments:
#     file  - The file to decrypt and decompress if it is properly compressed
#             and encrypted and contains the ".tar.xz.gpg" file extension;
#             the file to compress and encrypt otherwise.

main() {
    local -ar files=("${@}")
    local -r password="$(getPassword)"
    cachePassword || exit 1

    for file in "${files[@]}"; do
        if ! fileExists "${file}"; then
            echoError "Error: File does not exist. Cannot archive: ${file}."
            continue
        fi

        if isCompressedFile "${file}"; then
            echo "Extracting ${file}."
            extract "${file}" "${password}"
        else
            echo "Compressing ${file}."
            archive "${file}" "${password}"
        fi
    done
}

archive() {
    local -r file="${1}"
    local -r password="${2}"
    local -r name="${file%/}"  # Remove the trailing slash if it exists.

    tar --create --file="${name}.tar.xz" --xattrs --xattrs-include="*" --xz \
            "${name}"
    gpg --batch --cipher-algo "AES256" --digest-algo "SHA512" \
            --output "${name}.tar.xz.gpg" --passphrase "${password}" --sign \
            --symmetric "${name}.tar.xz" > /dev/null 2>&1
    rm "${name}.tar.xz"
}

extract() {
    local -r file="${1}"
    local -r password="${2}"
    local -r name="${file%".tar.xz.gpg"}"  # Remove the file extension.

    gpg --batch --decrypt --output "${name}.tar.xz" --passphrase "${password}" \
            "${name}.tar.xz.gpg" > /dev/null 2>&1 || {
            echoError "Error: Incorrect password. Failed to extract: ${file}.";
            return; }
    tar --backup="numbered" --extract --file="${name}.tar.xz" --xattrs \
            --xattrs-include="*" --xz
    rm "${name}.tar.xz"
}

getPassword() {
    local prompt="Enter password: "
    while true; do
        read -rsp "${prompt}" password < /dev/tty
        echo > /dev/tty
        read -rsp "Confirm password: " passwordReentry < /dev/tty
        echo > /dev/tty
        [[ "${password}" == "${passwordReentry}" ]] && break
        prompt="Enter password (try again): "
    done

    echo "${password}"
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
