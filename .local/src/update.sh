#!/bin/bash
#
# Update Arch Linux packages.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     update

main() {
    echo "Updating packages..."

    if hasUpdates; then
        yay
        pacdiff --sudo
        ${SHELL}
    fi
}

hasUpdates() {
    checkupdates
}

main "${@}"
