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
        yay --noconfirm
        pacdiff --sudo
        ${SHELL}
    fi
}

hasUpdates() {
    while checkupdates; local status="${?}"; [[ "${status}" -eq 1 ]]; do
        sleep 5
    done

    return "${status}"
}

main "${@}"
