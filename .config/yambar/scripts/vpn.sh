#!/bin/bash
#
# Yambar script to display active VPN connections.

main() {
    if isConnected; then
        local -r region="$(getRegion)"
        echo "isConnected|bool|true"
        echo -e "region|string|${region}\n"
    fi
}

getRegion() {
    local -r interface="$(getInterface)"
    echo "${interface:30:2}"
}

getInterface() {
    wg show 2>&1
}

isConnected() {
    local -r interface="$(getInterface)"
    ! isStringNull "${interface}"
}

isStringNull() {
    string="${1}"
    [[ -z "${string}" ]]
}

main
