#!/bin/bash
#
# Displays the network status.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printNetwork
}

printNetwork() {
    local network
    network="$(getNetwork)"
    if isConnected "${network}"; then
        echo " 📶$(getConnectedNetwork "${network}") "
    elif isConnecting "${network}"; then
        echo " 📡Connecting "
    else
        echo " 🌐Disconnected "
    fi
}

getNetwork() {
    nmcli device
}

isConnected() {
    local network="${1}"
    echo "${network}" | grep --quiet --word-regexp "connected"
}

getConnectedNetwork() {
    local network="${1}"
    echo "$network" | grep --word-regexp "connected" | awk '{print $4}'
}

isConnecting() {
    local network="${1}"
    echo "${network}" | grep --quiet --word-regexp "connecting"
}

main
