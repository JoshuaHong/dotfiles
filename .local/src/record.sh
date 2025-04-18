#!/bin/bash
#
# Record the screen.
#
# Begin recording if no recording is in process.
# Stop recording and exit otherwise.
#
# Arguments:
#     full   - Record the full screen.
#     select - Record a selection of the screen.

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
    fi
}

isRecording() {
    pgrep --exact "wf-recorder" > /dev/null
}

stopRecording() {
    killall "wf-recorder"
}

recordFullScreen() {
    wf-recorder --audio -f "${HOME}/$(date --iso-8601="seconds").mkv"
}

recordPartialScreen() {
    wf-recorder --audio --geometry "$(slurp)" -f "${HOME}/$(date --iso-8601="seconds").mkv"
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
