#!/bin/bash
#
# Record the screen.
#
# Begin recording if no recording is in process.
# Stop recording and exit otherwise.
#
# Usage:
#     record [full | select]
#
# Arguments:
#     full   - Record the full screen.
#     select - Record a selection of the screen.

# Select the audio device from: `pactl list sources | grep Name`
declare -a AUDIO_DEVICE="alsa_output.pci-0000_c5_00.6.HiFi__Speaker__sink.monitor"

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
    wf-recorder --audio="${AUDIO_DEVICE}" -f "${HOME}/$(date --iso-8601="seconds").mkv"
}

recordPartialScreen() {
    wf-recorder --audio="${AUDIO_DEVICE}" --geometry "$(slurp)" -f "${HOME}/$(date --iso-8601="seconds").mkv"
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
