#!/bin/bash
#
# Update Arch Linux packages.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     update

# Set default Bash options.
set -o errexit
set -o nounset
set -o pipefail

# Define global variables.
declare -gir WAYBAR_SIGNAL_UPDATES=1

main() {
    echo "Updating packages..."

    if hasUpdates; then
        yay --noconfirm
        pkill -SIGRTMIN+"${WAYBAR_SIGNAL_UPDATES}" waybar
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
