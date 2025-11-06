#!/bin/bash
#
# Lock the display.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     lock

main() {
    playerctl --no-messages pause
    mpc pause
    swaylock --image "${XDG_DATA_HOME}/backgrounds/lockscreen.png"
}

main "${@}"
