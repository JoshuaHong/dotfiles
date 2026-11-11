#!/bin/bash
#
# Update Arch Linux packages.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#     ${XDG_CONFIG_HOME}/waybar/config.jsonc
#
# Usage:
#     update [--list]
#
# Arguments:
#     --list - List all available updates.

# Set default Bash options.
set -o errexit
set -o nounset
set -o pipefail

# Define global variables.
declare -gir WAYBAR_UPDATES_SIGNAL=1
declare -gir RETRY_DELAY_SECS=5
declare -gr LIST_FLAG="--list"

main() {
    local -r flag="${1:-}"

    if [[ -z "${flag}" ]]; then
        update
    elif [[ "${flag}" == "${LIST_FLAG}" ]]; then
        listUpdates
    else
        echoError "ERROR: Invalid flag \"${flag}\""
        exit 1
    fi
}

update() {
    echo "Fetching updates..."
    local -r updates="$(listUpdates)"

    if [[ -n "${updates}" ]]; then
        echo "${updates}"
        yay --noconfirm
        pkill -SIGRTMIN+"${WAYBAR_UPDATES_SIGNAL}" waybar
        pacdiff --sudo
        ${SHELL}
    fi
}

listUpdates() {
    while checkupdates; local status="${?}"; [[ "${status}" -eq 1 ]]; do
        sleep "${RETRY_DELAY_SECS}"
    done
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
