#!/bin/bash
#
# Lists urls from stdin in dmenu and the selected url is opened in $BROWSER
# Useful for opening links from the terminal output

set -o errexit
set -o nounset
set -o pipefail

main() {
    local stdin
    stdin="$(getStdin)"
    local urls
    urls="$(parseUniqueURLs "${stdin}")"
    local selectedURL
    selectedURL=$(getURL "${urls}")
    openURL "${selectedURL}" "${urls}"
}

getStdin() {
    echo "$(</dev/stdin)"
}

parseUniqueURLs() {
    local stdin="${1}"
    urlRegex='(((http|https|ftp|gopher)|mailto)[.:][^ >"\t]*|www\.[-a-z0-9.]+)[^ .,;\t>">\):]'
    echo "${stdin}" | grep --perl-regexp --only-matching "${urlRegex}" | uniq
}

getURL() {
    local urls="${1}"
    echo "${urls}" | dmenu -p "Open:" -w "$(getWindowId)"
}

getWindowId() {
    echo "${WINDOWID}"
}

openURL() {
    local selectedURL="${1}"
    local urls="${2}"
    if isValidURL "${selectedURL}" "${urls}"; then
        "$(getBrowser)" "${selectedURL}"
    fi
}

isValidURL() {
    local selectedURL="${1}"
    local urls="${2}"
    echo "${selectedURL}" | grep --quiet --fixed-strings --line-regexp "${urls}"
}

getBrowser() {
    echo "${BROWSER}"
}

main
