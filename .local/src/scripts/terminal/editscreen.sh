#!/bin/bash
#
# Opens stdin in $EDITOR
# Useful for viewing terminal output and copying text

set -o errexit
set -o nounset
set -o pipefail

main() {
    local stdin
    stdin="$(getStdin)"
    local outputFile
    outputFile="$(initOutputFile)"
    setTraps "${outputFile}"
    writeToFile "${stdin}" "${outputFile}"
    openFile "${outputFile}"
}

getStdin() {
    echo "$(</dev/stdin)"
}

initOutputFile() {
    mktemp /tmp/terminal-output.XXXXXX
}

setTraps() {
    local outputFile="${1}"
    trap "cleanup ${outputFile}" EXIT
}

cleanup() {
    local outputFile="${1}"
    if regularFileExists "${outputFile}"; then
        rm "${outputFile}"
    fi
}

regularFileExists() {
    local file="${1}"
    [[ -f "${file}" ]]
}

writeToFile() {
    local stdin="${1}"
    local file="${2}"
    echo "${stdin}" > "${file}"
}

openFile() {
    local file="${1}"
    "$(getTerminal)" -e "$(getEditor)" "${file}"
}

getTerminal() {
    echo "${TERMINAL}"
}

getEditor() {
    echo "${EDITOR}"
}

main
