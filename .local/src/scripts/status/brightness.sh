#!/bin/bash
#
# Displays the brightness.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printBrightness
    notifyBrightness
}

printBrightness() {
    echo " 💡$(getBrightness)%"
}

getBrightness() {
    xbacklight -get | cut --delimiter="." --fields="1"
}

notifyBrightness() {
    notify "Brightness" "💡  $(getBar)$(getPadding)  $(getBrightness)%"
}

notify() {
    dunstify --hints="string:x-canonical-private-synchronous:brightness" "${@}"
}

getBar() {
    seq -s "─" "$(("$(getBrightness)" / 5 + 1))" | sed 's/[0-9]//g'
}

# Add padding to keep a fixed length and avoid shifting the text to recenter
getPadding() {
    local brightness
    local spaces
    brightness="$(getBrightness)"
    spaces="$(getSpaces "${brightness}")"
    if isInSingleDigits "${brightness}"; then
        echo "${spaces}  "
    elif isInDoubleDigits "${brightness}"; then
        echo "${spaces} "
    fi
}

getSpaces() {
    local brightness="${1}"
    seq -s " " "$(((104 - "${brightness}") / 5 + 1))" | sed 's/[0-9]//g'
}

isInSingleDigits() {
    local volume="${1}"
    local singleDigits=9
    [[ "${volume}" -le "${singleDigits}" ]]
}

isInDoubleDigits() {
    local volume="${1}"
    local doubleDigits=99
    [[ "${volume}" -le "${doubleDigits}" ]]
}

main
