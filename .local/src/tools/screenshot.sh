#!/bin/bash
#
# Captures a screenshot

set -o errexit
set -o nounset
set -o pipefail

main() {
    getOptions "${@}"
    screenshot
}

getOptions() {
    local options="hs"
    s="false"
    while getopts "${options}" flag; do
        case "${flag}" in
            s)
                s="true"
                ;;
            h)
                usage
                exit "0"
                ;;
            *)
                error "Error: Unsupported option"
                usage
                exit "1"
                ;;
        esac
    done
}

usage() {
    echo "Captures a screenshot"
    echo "Options:"
    echo "    -h: Help menu"
    echo "    -s: Select an area to capture with the mouse"
}

error() {
    local errorMessage="${*}"
    echo "${errorMessage}" 1>&2
}

getFlag() {
    local flag="${1}"
    [[ "${flag}" == "true" ]]
}

screenshot() {
    local screenshotsDirectory="${HOME}/media/images/screenshots"
    if directoryExists "${screenshotsDirectory}"; then
        if getFlag "${s}"; then
            captureSelectedScreenshot "${screenshotsDirectory}"
        else
            captureScreenshot "${screenshotsDirectory}"
        fi
    else
        notify "Screenshot" "Directory does not exist:\n${screenshotsDirectory}"
    fi
}

directoryExists() {
    local directory="${1}"
    [ -d "${directory}" ]
}

captureScreenshot() {
    local screenshotsDirectory="${1}"
    local dateTimeISO8601
    dateTimeISO8601="$(getDateTimeISO8601)"
    scrot "${screenshotsDirectory}/${dateTimeISO8601}.png"
    notify "Screenshot Taken" "📸 ${dateTimeISO8601}"
}

captureSelectedScreenshot() {
    sleep 0.1    # Dwm needs time to render the selection
    local screenshotsDirectory="${1}"
    local dateTimeISO8601
    dateTimeISO8601="$(getDateTimeISO8601)"
    notify "Screenshot" "📷 Drag mouse to capture"
    scrot -s "${screenshotsDirectory}/${dateTimeISO8601}.png"
    notify "Screenshot Taken" "📸 ${dateTimeISO8601}"
}

getDateTimeISO8601() {
    date --iso-8601=seconds
}

notify() {
  dunstify --hints="string:x-canonical-private-synchronous:screenshot" "$@"
}

main "${@}"
