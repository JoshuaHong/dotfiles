#!/bin/bash
#
# Record the screen.
#
# Begin recording if no recording is in process.
# Stop recording and exit otherwise.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     record [full | select]
#
# Arguments:
#     full   - Record the full screen.
#     select - Record a selection of the screen.

# Select the audio device from: `pactl list sources | grep Name`
declare -gr AUDIO_DEVICE="alsa_output.pci-0000_c5_00.6.HiFi__Speaker__sink.monitor"
declare -gr ICONS_DIRECTORY="${XDG_DATA_HOME}/assets/icons"

main() {
    local -r operation="${1}"

    if isRecording; then
        stopRecording
        exit 0
    fi

    if [[ "${operation}" == "full" ]]; then
        recordFullScreen
    elif [[ "${operation}" == "select" ]]; then
        recordPartialScreen
    else
        echoError "Error: Invalid operation."
        exit 1
    fi
}

isRecording() {
    pgrep --exact "wf-recorder" > /dev/null
}

stopRecording() {
    killall "wf-recorder"
}

recordFullScreen() {
    notify "Full screen recording started."
    wf-recorder --audio="${AUDIO_DEVICE}" \
            -f "${HOME}/$(date --iso-8601="seconds").mkv"
    notify "Screen recording saved."
}

recordPartialScreen() {
    local -r region="$(slurp)"
    notify "Partial screen recording started."
    wf-recorder --audio="${AUDIO_DEVICE}" --geometry "${region}" \
            -f "${HOME}/$(date --iso-8601="seconds").mkv"
    notify "Screen recording saved."
}

notify() {
    local -r description="${1}"

    notify-send --hint="string:x-canonical-private-synchronous:record" \
            --icon="${ICONS_DIRECTORY}/record.svg" \
            "Recording" "${description}"
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
