#!/bin/bash
#
# Switch the keyboard language.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#     ${XDG_CONFIG_HOME}/waybar/config.jsonc
#
# Usage:
#     language

main() {
    fcitx5-remote -t
    niri msg action switch-layout next
}

main "${@}"
