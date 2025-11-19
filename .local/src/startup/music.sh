#!/bin/bash
#
# Initialize the music player.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     music

main() {
    mpc load all
    mpc random on
}

main "${@}"
