#!/bin/bash
#
# Prints the RGB value of the selected pixel.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printColor
}

printColor() {
    notify "Eyedropper" "🧫 Click to capture"
    local color
    color="$(getColor)"
    notify "Eyedropper" "🧫 ${color}"
    echo "${color}"
}

getColor() {
    maim -st 0 | convert - -resize 1x1\! -format '%[pixel:p{0,0}]' info:-
}

notify() {
  dunstify --hints="string:x-canonical-private-synchronous:eyedropper" "$@"
}

main
