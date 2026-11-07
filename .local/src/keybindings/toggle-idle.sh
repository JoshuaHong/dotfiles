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
declare -gir WAYBAR_SIGNAL_IDLE=2

main() {
    pkill -SIGRTMIN+"${WAYBAR_SIGNAL_IDLE}" waybar
}

main "${@}"
