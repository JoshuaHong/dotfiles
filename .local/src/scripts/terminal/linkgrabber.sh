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
    selectedURL="$(getURL "${urls}")"
    openURL "${selectedURL}" "${urls}"
}

getStdin() {
    echo "$(</dev/stdin)"
}

parseUniqueURLs() {
    local stdin="${1}"
    urlRegex='(((http|https|ftp|gopher)|mailto)[.:][^ >"\t]*|www\.[-a-z0-9.]+)[^ .,;\t>">\):]'
    echo "${stdin}" | grep --perl-regexp --only-matching "${urlRegex}" | uniq \
            || true
}

getURL() {
    local urls="${1}"
    if isEmpty "${urls}"; then
        echo "" | dmenu -p "No URLs" -w "$(getWindowId)"
    else
        echo "${urls}" | dmenu -i -p "Open:" -w "$(getWindowId)"
    fi
}

isEmpty() {
    local variable="${1}"
    [[ -z "${variable}" ]]
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
    if isEmpty "${selectedURL}"; then
        false
    else
        echo "${selectedURL}" \
                | grep --quiet --fixed-strings --line-regexp "${urls}"
    fi
}

getBrowser() {
    echo "${BROWSER}"
}

main
