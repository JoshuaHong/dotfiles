#!/bin/bash
#
# Lock the display.

main() {
    playerctl --no-messages pause
    swaylock --image "${XDG_DATA_HOME}/backgrounds/lockscreen.png"
}

main
