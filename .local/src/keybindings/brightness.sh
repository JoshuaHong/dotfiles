#!/bin/bash
#
# Manage the system backlight brightness.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     brightness [up | down | save | restore | set value]
#
# Arguments:
#     up      - Raise the brightness by INCREMENT.
#     down    - Lower the brightness by INCREMENT.
#     save    - Save the brightness temporarily.
#     restore - Restore the saved brightness.
#     set     - Set the brightness to value.

declare -gr DEVICE="amdgpu_bl1"
declare -gr INCREMENT="5%"
declare -gr BRIGHTNESS_ICON="${XDG_DATA_HOME}/assets/icons/brightness.svg"

main() {
    local -r action="${1}"
    local -r value="${2}"

    if [[ "${action}" == "up" ]]; then
        raise
    elif [[ "${action}" == "down" ]]; then
        lower
    elif [[ "${action}" == "save" ]]; then
        save
    elif [[ "${action}" == "restore" ]]; then
        restore
    elif [[ "${action}" == "set" ]]; then
        set "${value}"
    else
        echoError "Error: Invalid operation."
        exit 1
    fi
}

raise() {
    brightnessctl --class="backlight" --device="${DEVICE}" set "+${INCREMENT}"
    notify
}

lower() {
    brightnessctl --class="backlight" --device="${DEVICE}" set "${INCREMENT}-"
    notify
}

save() {
    brightnessctl --class="backlight" --device="${DEVICE}" --save
}

restore() {
    brightnessctl --class="backlight" --device="${DEVICE}" --restore
}

set() {
    local -r value="${1}"
    if ! isVariableSet "${value}"; then
        echoError "Error: Invalid brightness value."
        exit 1
    fi

    brightnessctl --class="backlight" --device="${DEVICE}" set "${value}"
}

notify() {
    local -r brightness="$(brightnessctl --device="${DEVICE}" get)"
    local -r maxBrightness="$(brightnessctl --device="${DEVICE}" max)"
    local -r value="$(( "${brightness}" * 100 / "${maxBrightness}" ))"

    notify-send --hint="string:x-canonical-private-synchronous:brightness" \
            --hint="int:value:${value}" --icon="${BRIGHTNESS_ICON}" \
            "Brightness" "${value}%"
}

isVariableSet() {
    local -r variable="${1}"
    [[ -n "${variable}" ]]
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
