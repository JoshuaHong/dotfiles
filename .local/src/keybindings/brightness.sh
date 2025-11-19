#!/bin/bash
#
# Manage the system backlight brightness.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     brightness [up | down]
#
# Arguments:
#     up     - Raise the brightness.
#     down   - Lower the brightness.

declare -gr ICONS_DIRECTORY="${XDG_DATA_HOME}/assets/icons"

main() {
    local -r action="${1}"

    if [[ "${action}" == "up" ]]; then
        raise
    elif [[ "${action}" == "down" ]]; then
        lower
    else
        echoError "Error: Invalid operation."
        exit 1
    fi

    notify
}

raise() {
    brightnessctl --class=backlight set +5%
}

lower() {
    brightnessctl --class=backlight set 5%-
}

notify() {
    local -r brightness="$(brightnessctl get)"
    local -r maxBrightness="$(brightnessctl max)"
    local -r value="$(( "${brightness}" * 100 / "${maxBrightness}" ))"

    notify-send --hint="string:x-canonical-private-synchronous:brightness" \
            --hint="int:value:${value}" \
            --icon="${ICONS_DIRECTORY}/brightness.svg" \
            "Brightness" "${value}%"
}


echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
