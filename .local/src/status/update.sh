#!/bin/bash
#
# Updates packages.

set -o errexit
set -o nounset
set -o pipefail

main() {
    getOptions "${@}"
    fetchUpdates
    refreshDwmBlocks
}

getOptions() {
    local options="chl"
    while getopts "${options}" flag; do
        case "${flag}" in
            c)
                countUpdates
                exit 0
                ;;
            h)
                usage
                exit 0
                ;;
            l)
                getUpdates
                exit 0
                ;;
            *)
                error "Error: Unsupported option"
                usage
                exit 1
                ;;
        esac
    done
}

usage() {
    echo "Updates packages"
    echo "Options:"
    echo "    -c: Count updates"
    echo "    -h: Help menu"
    echo "    -l: List updates"
}

error() {
    local errorMessage="${*}"
    echo "${errorMessage}" 1>&2
}

countUpdates() {
    local updates
    updates="$(getUpdates)"
    if hasError "${updates}"; then
        echo "📥"
    elif hasUpdates "${updates}"; then
        echo "📥$(getNumberOfUpdates "${updates}")"
    fi
}

getUpdates() {
    checkupdates 2>&1
}

hasError() {
    local updates="${1}"
    echo "${updates}" | grep --quiet "ERROR"
}

hasUpdates() {
    local updates="${1}"
    [[ -n ${updates} ]]
}

getNumberOfUpdates() {
    local updates="${1}"
    echo "${updates}" | wc --lines
}

fetchUpdates() {
    yay -Syu
}

refreshDwmBlocks() {
    local signal=46
    kill -"${signal}" "$(pidof dwmblocks)"
}

main "${@}"
