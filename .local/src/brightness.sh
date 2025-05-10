#!/bin/bash
#
# Set the backlight brightness.
#
# Usage:
#     brightness [up | down | restore]
#
# Arguments:
#     up      - Raise the brightness by 1%.
#     down    - Lower the brightness by 1%.
#     restore - Restore the previously saved brightness.

declare -gr SAVE_BRIGHTNESS_FILE="${XDG_STATE_HOME}/brightnessctl/intel_backlight"
declare -gr TEMP_BRIGHTNESS_FILE="${XDG_RUNTIME_DIR}/brightnessctl/backlight/intel_backlight"

main() {
    local -r operation="${1}"
    if [[ "${operation}" == "up" ]]; then
        raiseBrightness
    elif [[ "${operation}" == "down" ]]; then
        lowerBrightness
    elif [[ "${operation}" == "restore" ]]; then
        restoreBrightness
    else
        echoError "Error: Invalid operation."
        exit 1
    fi
}

raiseBrightness() {
    brightnessctl set 1%+
    saveState
}

lowerBrightness() {
    brightnessctl set 1%-
    saveState
}

restoreBrightness() {
    brightnessctl set "$(< "${SAVE_BRIGHTNESS_FILE}")"
    saveState
}

saveState() {
    brightnessctl --save && cp --force "${TEMP_BRIGHTNESS_FILE}" "${SAVE_BRIGHTNESS_FILE}"
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
