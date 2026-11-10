#!/bin/bash
#
# Toggle the idle inhibitor.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     toggle_idle

# Define global variables.
declare -gir WAYBAR_IDLE_SIGNAL=2

main() {
    pkill -SIGRTMIN+"${WAYBAR_IDLE_SIGNAL}" waybar
}

main "${@}"
