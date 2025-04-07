#!/bin/bash
#
# Yambar script to display the active Hyprland window name.

activeWindowJson="$(hyprctl activewindow -j)"
windowName="$(echo ${activeWindowJson} | jq --raw-output ".class // empty")"
echo "windowName|string|${windowName}"
echo ""
