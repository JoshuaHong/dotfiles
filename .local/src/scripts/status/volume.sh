#!/bin/bash
#
# Displays the volume.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printVolume
    notifyVolume
}

printVolume() {
    echo " $(getIcon)$(getVolume)%"
}

getIcon() {
    if isMuted; then
        echo "🔇"
    else
        local volume
        volume="$(getVolume)"
        if isLowVolume "${volume}"; then
            echo "🔈"
        elif isMediumVolume "${volume}"; then
            echo "🔉"
        else
            echo "🔊"
        fi
    fi
}

getVolume() {
    pamixer --get-volume
}

isMuted() {
    pamixer --get-mute > /dev/null
}

isLowVolume() {
    local lowVolume=33
    [[ ${volume} -le "${lowVolume}" ]]
}

isMediumVolume() {
    local mediumVolume=66
    [[ ${volume} -le "${mediumVolume}" ]]
}

notifyVolume() {
    notify "Volume" "$(getIcon)  $(getBar)$(getPadding)  $(getVolume)%"
}

notify() {
    dunstify --hints="string:x-canonical-private-synchronous:volume" "${@}"
}

getBar() {
    seq -s "─" "$(("$(getVolume)" / 5 + 1))" | sed 's/[0-9]//g'
}

# Add padding to keep a fixed length and avoid shifting the text to recenter
getPadding() {
    local volume
    local spaces
    volume="$(getVolume)"
    spaces="$(getSpaces "${volume}")"
    if isInSingleDigits "${volume}"; then
        echo "${spaces}  "
    elif isInDoubleDigits "${volume}"; then
        echo "${spaces} "
    fi
}

getSpaces() {
    local volume="${1}"
    seq -s " " "$(((104 - "${volume}") / 5 + 1))" | sed 's/[0-9]//g'
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
