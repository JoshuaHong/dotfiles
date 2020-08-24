#!/bin/bash
#
# Captures a screenshot.

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
    local screenshotDirectory="${HOME}/media/images/screenshots"
    if directoryExists "${screenshotDirectory}"; then
        local screenshot
        if getFlag "${s}"; then
            screenshot="$(captureSelectedScreenshot)"
        else
            screenshot="$(captureScreenshot)"
        fi
        local screenshotName
        screenshotName="$(getScreenshotName "${screenshotDirectory}")"
        createScreenshotFile "${screenshot}" \
                "${screenshotDirectory}/${screenshotName}.png"
        notify "Screenshot Taken" "📸 ${screenshotName}"
    else
        notify "Screenshot" "Directory does not exist:\n${screenshotDirectory}"
    fi
}

directoryExists() {
    local directory="${1}"
    [ -d "${directory}" ]
}

captureScreenshot() {
    maim | base64 -w "0"
}

captureSelectedScreenshot() {
    notify "Screenshot" "📷 Drag mouse to capture"
    maim -s | base64 -w "0"
}

getScreenshotName() {
    local screenshotDirectory="${1}"
    local dateTimeISO8601
    dateTimeISO8601="$(getDateTimeISO8601)"
    local screenshotName="${dateTimeISO8601}"
    local duplicateNumber
    duplicateNumber="$(getDuplicateNumber "${screenshotName}" \
            "${screenshotDirectory}")"
    if hasDuplicates "$duplicateNumber"; then
        screenshotName="${dateTimeISO8601}.${duplicateNumber}"
    fi
    echo "${screenshotName}"
}

getDateTimeISO8601() {
    date --iso-8601=seconds
}

getDuplicateNumber() {
    local name="${1}"
    local directory="${2}"
    find "${directory}" -name "${name}*" -type "f" | wc --lines
}

hasDuplicates() {
    local duplicateNumber="${1}"
    [[ "${duplicateNumber}" -gt 0 ]]
}

createScreenshotFile() {
    local screenshot="${1}"
    local screenshotFile="${2}"
    echo "${screenshot}" | base64 -d > "${screenshotFile}"
}

notify() {
  dunstify --hints="string:x-canonical-private-synchronous:screenshot" "$@"
}

main "${@}"
