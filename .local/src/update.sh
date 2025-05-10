#!/bin/bash
#
# Update Gentoo packages.
#
# Usage:
#     update

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

main
