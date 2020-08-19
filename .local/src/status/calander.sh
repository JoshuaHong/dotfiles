#!/bin/bash
#
# Displays the calander date.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printDate
}

printDate() {
    echo "📅$(getDate)"
}

getDate() {
    date "+%a %b %d"
}

main
