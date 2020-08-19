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
    echo "💡$(getBrightness)%"
}

getBrightness() {
    xbacklight -get | cut --delimiter="." --fields="1"
}

notifyBrightness() {
    notify "Brightness" "💡  $(getBar)$(getPadding)  $(getBrightness)%"
}

getBar() {
    seq -s "─" "$(("$(getBrightness)" / 5 + 1))" | sed 's/[0-9]//g'
}

# Add padding to keep a fixed length and avoid shifting the text to recenter
getPadding() {
    local brightness
    local spaces
    brightness="$(getBrightness)"
    spaces="$(seq -s " " "$(((104 - "${brightness}") / 5 + 1))" \
            | sed 's/[0-9]//g')"
    if [[ "${brightness}" -lt 10 ]]; then
        echo "${spaces}  "
    elif [[ "${brightness}" -lt 100 ]]; then
        echo "${spaces} "
    fi
}

notify() {
    dunstify --hints="string:x-canonical-private-synchronous:brightness" "${@}"
}

main
