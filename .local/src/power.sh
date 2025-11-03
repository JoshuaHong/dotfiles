#!/bin/bash
#
# Manage the system power.
#
# Usage:
#     power

declare -ar OPTIONS=("exit" "reboot" "poweroff" "suspend" "hybrid-sleep" "hibernate")

main() {
    local -r option="$(selectOption)"
    if [[ "${option}" == "exit" ]]; then
        niri msg action quit
    elif arrayContains OPTIONS "${option}"; then
        systemctl "${option}"
    fi
}

selectOption() {
    printf "%s\n" "${OPTIONS[@]}" | fuzzel --dmenu
}

arrayContains() {
    local -nr array="${1}"
    local -r value="${2}"
    [[ " ${array[*]} " =~ " ${value} " ]]
}

main
