#!/bin/bash
#
# Yambar script to display Hyprland workspaces.

occupiedWorkspacesJson="$(hyprctl workspaces -j)"
activeWorkspaceJson="$(hyprctl activeworkspace -j)"
occupiedWorkspaceNums="$(echo ${occupiedWorkspacesJson} | jq ".[].id")"
activeWorkspaceNum="$(echo ${activeWorkspaceJson} | jq ".id")"

for occupiedWorkspaceNum in ${occupiedWorkspaceNums[@]}; do
    isWorkspaceOccupied=false
    if [[ "${occupiedWorkspaceNum}" == "${activeWorkspaceNum}" ]]; then
        isWorkspaceOccupied=true
    fi
    echo "isWorkspace${occupiedWorkspaceNum}Active|string|${isWorkspaceOccupied}"
done

echo ""
