#!/bin/bash
#
# Switch the keyboard language.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     language

main() {
    fcitx5-remote -t
}

main "${@}"
