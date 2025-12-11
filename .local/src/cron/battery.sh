#!/bin/bash
#
# Notify on low battery.
#
# Usage:
#     battery.sh

declare -gr BATTERY_DIRECTORY="/sys/class/power_supply/BAT0"
declare -gr CAPACITY_FILE="${BATTERY_DIRECTORY}/capacity"
declare -gr STATUS_FILE="${BATTERY_DIRECTORY}/status"
declare -gr ICONS_DIRECTORY="/home/josh/.local/share/assets/icons"
declare -gr CRITICAL_PERCENTAGE="5"
declare -gir LOW_PERCENTAGE="15"
declare -gir FULL_PERCENTAGE="95"

main() {
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

    if [[ "$(getBattery)" -le "${CRITICAL_PERCENTAGE}" ]] && isDischarging; then
        notify "Critical battery" "critical" "critical"
    elif [[ "$(getBattery)" -le "${LOW_PERCENTAGE}" ]] && isDischarging; then
        notify "Low battery" "normal" "low"
    elif [[ "$(getBattery)" -ge "${FULL_PERCENTAGE}" ]] && ! isDischarging; then
        notify "Full battery" "normal" "full"
    fi
}

getBattery() {
    cat "${CAPACITY_FILE}"
}

isDischarging() {
    [[ $(cat "${STATUS_FILE}") == "Discharging" ]]
}

notify() {
    local -r title="${1}"
    local -r urgency="${2}"
    local -r icon="${3}"

    notify-send --hint="string:x-canonical-private-synchronous:battery" \
        --icon="${ICONS_DIRECTORY}/battery-${icon}.svg" \
        --urgency="${urgency}" \
    "${title}" "$(getBattery)% remaining."
}

main "${@}"
