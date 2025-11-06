#!/bin/bash
#
# Initialize the music player.
#
# Usage:
#     music

main() {
    mpc load all
    mpc random on
}

main "${@}"
