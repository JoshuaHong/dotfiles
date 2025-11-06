#!/bin/bash
#
# Lock the display.
#
# Usage:
#     lock

playerctl --no-messages pause
mpc pause
swaylock --image "${XDG_DATA_HOME}/backgrounds/lockscreen.png"
