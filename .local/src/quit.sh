#!/bin/bash
#
# Quit the system.
#
# Usage:
#     quit

declare -ar OPTIONS=("exit" "poweroff" "reboot")

main() {
    local -r option="$(selectOption)"
    if [[ "${option}" == "exit" ]]; then
        hyprctl dispatch exit
    elif arrayContains OPTIONS "${option}"; then
        sudo --askpass "${option}"
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
