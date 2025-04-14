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
