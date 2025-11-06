#!/bin/bash
#
# Update Arch Linux packages.
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
