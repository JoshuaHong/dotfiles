#!/bin/bash
#
# Suspend if locked.
#
# References:
#     ${XDG_CONFIG_HOME}/swayidle/config
#
# Usage:
#     suspend-if-locked

main() {
    if isLocked; then
        systemctl suspend
    fi
}

isLocked() {
    pgrep -x "swaylock"
}

main "${@}"
