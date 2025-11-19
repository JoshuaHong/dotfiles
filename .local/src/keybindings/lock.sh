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
    swaylock --image "${XDG_DATA_HOME}/assets/backgrounds/lockscreen.png"
}

main "${@}"
