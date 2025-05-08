#!/bin/bash
#
# Update Gentoo packages.

main() {
    echo -e "Updating Gentoo packages."
    callFunctionWithSudo "update"
    echo -e "\nDone."
}

callFunctionWithSudo() {
    local -r function="${1}"
    sudo --askpass bash -c "$(declare -f "${function}"); ${function}"
}

update() {
    emaint --auto sync
    emerge --ask --deep --newuse --update --verbose --with-bdeps=y @world
    emerge --ask --depclean
    emerge @preserved-rebuild
    eselect news read
    eselect news purge
    dispatch-conf
}

isRoot() {
    [[ "${EUID}" -eq 0 ]]
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main
