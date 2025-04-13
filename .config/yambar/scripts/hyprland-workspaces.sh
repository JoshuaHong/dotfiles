#!/bin/bash
#
# Yambar script to display Hyprland workspaces.

main() {
    local -r occupiedWorkspaceIds="$(getJsonIdList "$(fetchOccupiedWorkspacesJson)")"
    local -r activeWorkspaceId="$(getJsonId "$(fetchActiveWorkspaceJson)")"
    printWorkspaces "${occupiedWorkspaceIds}" "${activeWorkspaceId}"
}

fetchOccupiedWorkspacesJson() {
    hyprctl workspaces -j
}

fetchActiveWorkspaceJson() {
    hyprctl activeworkspace -j
}

getJsonIdList() {
    local -r json="${1}"
    echo "${json}" | jq ".[].id"
}

getJsonId() {
    local -r json="${1}"
    echo "${json}" | jq ".id"
}

printWorkspaces() {
    local -ar occupiedWorkspaceIds=("${1}")
    local -r activeWorkspaceId="${2}"

    for occupiedWorkspaceId in ${occupiedWorkspaceIds[@]}; do
        local isWorkspaceOccupied=false
        if [[ "${occupiedWorkspaceId}" == "${activeWorkspaceId}" ]]; then
            isWorkspaceOccupied=true
        fi
        echo "isWorkspace${occupiedWorkspaceId}Active|string|${isWorkspaceOccupied}"
    done
    echo ""
}

main
