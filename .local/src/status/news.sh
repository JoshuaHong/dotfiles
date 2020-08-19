#!/bin/bash
#
# Displays the news.

set -o errexit
set -o nounset
set -o pipefail

main() {
    getOptions "${@}"
    openNews
    refreshDwmBlocks
}

getOptions() {
    local options="ch"
    while getopts "${options}" flag; do
        case "${flag}" in
            c)
                countUnread
                exit 0
                ;;
            h)
                usage
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
    echo "Displays the news"
    echo "Options:"
    echo "    -c: Count unread news"
    echo "    -h: Help menu"
}

error() {
    local errorMessage="${*}"
    echo "${errorMessage}" 1>&2
}

countUnread() {
    local news
    news="$(getNews)"
    if hasNews "${news}"; then
        echo "📰 ${news}"
    fi
}

getNews() {
    newsboat -x "reload" "print-unread" | awk '{print $1}'
}

hasNews() {
    local news="${1}"
    [[ "${news}" -gt 0 ]]
}

refreshDwmBlocks() {
    local signal=47
    kill -"${signal}" "$(pidof dwmblocks)"
}

openNews() {
    newsboat -r
}

main "${@}"
