#!/bin/bash
#
# Manage the system volume.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     volume [source | sink] [up | down | toggle]
#
# Arguments:
#     source - Manage the source volume.
#     sink   - Manage the sink volume.
#     up     - Raise the volume.
#     down   - Lower the volume.
#     toggle - Toggle the volume mute.

declare -gr INCREMENT="5%"
declare -gr ICONS_DIRECTORY="${XDG_DATA_HOME}/assets/icons"

main() {
    local -r node="${1}"
    local -r action="${2}"

    local -r id="$(getId "${node}")"
    if [[ "${action}" == "up" ]]; then
        wpctl set-volume "${id}" "${INCREMENT}+" --limit 1.0
    elif [[ "${action}" == "down" ]]; then
        wpctl set-volume "${id}" "${INCREMENT}-" --limit 1.0
    elif [[ "${action}" == "toggle" ]]; then
        wpctl set-mute "${id}" toggle
    else
        echoError "Error: Invalid operation."
       exit 1
    fi

    notify "${node}" "${id}"
}

getId() {
    local -r node="${1}"

    if [[ "${node}" == "source" ]]; then
        echo "@DEFAULT_AUDIO_SOURCE@"
    elif [[ "${node}" == "sink" ]]; then
        echo "@DEFAULT_AUDIO_SINK@"
    else
        echoError "Error: Invalid operation."
        exit 1
    fi
}

notify() {
    local -r node="${1}"
    local -r id="${2}"

    local -r volumeInfo="$(wpctl get-volume "${id}")"
    local -ir volume="$(parseVolume "${volumeInfo}")"
    local -r muteStatus="$(parseMute "${volumeInfo}")"
    notify-send --hint="string:x-canonical-private-synchronous:volume" \
            --hint="int:value:${volume}" \
            --icon="${ICONS_DIRECTORY}/volume-${node}-${muteStatus}.svg" \
            "Volume" "${volume}%"
}

parseVolume() {
    local -ar volumeInfo="(${1})"

    local -r value="${volumeInfo[1]}"
    if [[ "${value:0:1}" == "1" ]]; then
        echo "100"
    else
        echo "${value:2}"
    fi
}

parseMute() {
    local -ar volumeInfo="(${1})"

    if [[ "${volumeInfo[2]}" ]]; then
        echo "muted"
    else
        echo "unmuted"
    fi
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
