#!/bin/bash
#
# Yambar script to display the active Hyprland window name.

main() {
    local -r windowName="$(getJsonClassNameOrEmpty "$(fetchActiveWindowJson)")"
    echo -e "windowName|string|${windowName}\n"
}

fetchActiveWindowJson() {
    hyprctl activewindow -j
}

getJsonClassNameOrEmpty() {
    local -r json="${1}"
    echo "${json}" | jq --raw-output ".class // empty"
}

main
