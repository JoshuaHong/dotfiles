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
    echo " $(getIcon)$(getVolume)% "
}

getIcon() {
    if isMuted; then
        echo "🔇"
    else
        local volume
        volume="$(getVolume)"
        if [[ ${volume} -le 33 ]]; then
            echo "🔈"
        elif [[ ${volume} -le 66 ]]; then
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

notifyVolume() {
    notify "Volume" "$(getIcon)  $(getBar)$(getPadding)  $(getVolume)%"
}

getBar() {
    seq -s "─" "$(("$(getVolume)" / 5 + 1))" | sed 's/[0-9]//g'
}

# Add padding to keep a fixed length and avoid shifting the text to recenter
getPadding() {
    local volume
    local spaces
    volume="$(getVolume)"
    spaces="$(seq -s " " "$(((104 - "${volume}") / 5 + 1))" | sed 's/[0-9]//g')"
    if [[ ${volume} -lt 10 ]]; then
        echo "${spaces}  "
    elif [[ ${volume} -lt 100 ]]; then
        echo "${spaces} "
    fi
}

notify() {
    dunstify --hints="string:x-canonical-private-synchronous:volume" "${@}"
}

main
