#!/bin/bash
#
# Update Gentoo packages.

main() {
    if ! isRoot; then
        echoError "Error: Please run as root."
        exit 1
    fi

    update
    echo -e "\nDone."
}

update() {
    emaint --auto sync
    eselect news read
    eselect news purge
    emerge --ask --deep --newuse --update --verbose --with-bdeps=y @world
    dispatch-conf
    emerge --ask --depclean
}

isRoot() {
    [[ "${EUID}" -eq 0 ]]
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main
