#!/bin/bash
#
# Opens stdin in $EDITOR
# Useful for viewing terminal output and copying text

set -o errexit
set -o nounset
set -o pipefail

main() {
    local outputFile
    outputFile="$(initOutputFile)"
    setTraps "${outputFile}"
    writeToFile "${outputFile}"
    openFile "${outputFile}"
}

initOutputFile() {
    mktemp /tmp/terminal-output.XXXXXX
}

setTraps() {
    local outputFile="${1}"
    trap "rm ${outputFile}" EXIT
}

writeToFile() {
    local file="${1}"
    cat > "${file}"
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
