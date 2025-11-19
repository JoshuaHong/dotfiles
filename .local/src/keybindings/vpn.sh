#!/bin/bash
#
# Connect to the VPN.
#
# References:
#     none
#
# Usage:
#     vpn [connect [CONFIGURATION | REGION] | disconnect | toggle]
#
# Arguments:
#     auto          - Connect to a random server if disconnected.
#                         Disconnect from the connected server otherwise.
#     connect       - Connect to a random server if no server or region is
#                         provided.
#     disconnect    - Disconnect from the server.
#     CONFIGURATION - The config file to which to connect.
#     REGION        - The region to which to connect using a random server.
#                         One of: [JP | NL | US].

declare -gr CONFIGURATION_PATH="/etc/wireguard"
declare -agr REGIONS=("JP" "NL" "US")

main() {
    local -r operation="${1}"

    if ! isRoot; then
        echoError "Error: Must be run as root."
        exit 1
    fi

    if [[ "${operation}" == "connect" ]]; then
        local -r location="${2}"
        connect "${location}"
    elif [[ "${operation}" == "disconnect" ]]; then
        disconnect
    elif [[ "${operation}" == "toggle" ]]; then
        toggle
    else
        echoError "Error: Invalid operation."
        exit 1
    fi
}

connect() {
    local -r location="${1}"

    if isConnected; then
        echoError "Error: Already connected."
        exit 1
    fi

    if isStringNull "${location}"; then
        connectRandom
    elif arrayContains REGIONS "${location}"; then
        connectRegion "${location}"
    else
        connectConfiguration "${location}"
    fi
}

disconnect() {
    if ! isConnected; then
        echoError "Error: Already disconnected."
        exit 1
    fi

    local -r server="$(getServer)"
    wg-quick down "${server}"
}

toggle() {
    if isConnected; then
        disconnect
    else
        connect
    fi
}

connectRandom() {
    local -r randomConfiguration="$(ls ${CONFIGURATION_PATH}/ \
        | shuf --head-count=1)"
    wg-quick up "${CONFIGURATION_PATH}/${randomConfiguration}"
}

connectRegion() {
    local -r region="${1}"
    local -r randomConfiguration="$(ls ${CONFIGURATION_PATH}/wg-${region}-* \
        | shuf --head-count=1)"
    wg-quick up "${CONFIGURATION_PATH}/${randomConfiguration}"
}

connectConfiguration() {
    local -r configuration="${1}"
    wg-quick up "${configuration}"
}

getServer() {
    local -r interface=($(wg show | grep "interface:"))
    echo "${interface[1]}"
}

isConnected() {
    local -r connections="$(wg show)"
    ! isStringNull "${connections}"
}

isStringNull() {
    string="${1}"
    [[ -z "${string}" ]]
}

arrayContains() {
    local -nr array="${1}"
    local -r value="${2}"
    [[ " ${array[*]} " =~ " ${value} " ]]
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

isRoot() {
    [[ $(id -u) -eq 0 ]]
}

main "${@}"
