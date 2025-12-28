#!/bin/bash
#
# Archive files.
#
# Usage:
#     archive [compress | extract] file
#
# Arguments:
#     compress - Archive the file.
#     extract  - Unarchive the file.

main() {
    local -r action="${1}"
    local -r file="${2}"

    if ! fileExists "${file}"; then
        echoError "Error: File does not exist."
        exit 1
    fi

    if [[ "${action}" == "compress" ]]; then
        compress "${file}"
    elif [[ "${action}" == "extract" ]]; then
        extract "${file}"
    else
        echoError "Error: Invalid operation."
        exit 1
    fi
}

compress() {
    local -r file="${1}"

    tar --create --file="${file}.tar.xz" --xattrs --xattrs-include="*" --xz \
            "${file}"
    gpg --cipher-algo "AES256" --output "${file}.tar.xz.gpg" --symmetric \
            "${file}.tar.xz"
    rm "${file}.tar.xz"
}

extract() {
    local file="${1}"

    if ! isCompressedFile "${file}"; then
        echoError "Error: Invalid file format."
        exit 1
    fi

    file="${file%".tar.xz.gpg"}"
    gpg --decrypt --output "${file}.tar.xz" "${file}.tar.xz.gpg"
    tar --extract --file="${file}.tar.xz" --xattrs --xattrs-include="*" --xz
    rm "${file}.tar.xz"
}

fileExists() {
    local -r file="${1}"

    [[ -f "${file}" ]]
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
