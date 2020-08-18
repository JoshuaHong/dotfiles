#!/bin/bash

# Notifier script - lowers screen brightness, then waits to be killed.
# Restores previous brightness on exit.

set -o errexit
set -o nounset
set -o pipefail

function main() {
    if ! isVideoPlaying; then
        dim
    fi
}

isVideoPlaying() {
    local drivers="/proc/asound/card*/pcm*/sub*/status"
    cat ${drivers} | grep --quiet "state: RUNNING"
}

dim() {
    local minBrightness="5"
    setTraps
    fadeBrightness "${minBrightness}"
    sleep "infinity" &
    wait
}

setTraps() {
    trap "exit 0" "TERM" "INT"
    trap "cleanup $(getBrightness)" "EXIT"
}

cleanup() {
    local initialBrightness="${1}"
    setBrightness "${initialBrightness}"
    kill "%%"
}

fadeBrightness() {
    local brightness="${1}"
    local fadeTime="200"
    local fadeSteps="20"
    xbacklight -time "${fadeTime}" -steps "${fadeSteps}" -set "${brightness}"
}

getBrightness() {
    xbacklight -get
}

setBrightness() {
    local brightness="${1}"
    xbacklight -steps "1" -set "${brightness}"
}

main
