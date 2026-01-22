#!/bin/bash
#
# Lock the display.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     lock

declare -gr LOCKSCREEN="${XDG_DATA_HOME}/assets/backgrounds/lockscreen.png"

main() {
    playerctl --all-players --no-messages stop
    mpc pause
    swaylock --image "${LOCKSCREEN}"
}

main "${@}"
