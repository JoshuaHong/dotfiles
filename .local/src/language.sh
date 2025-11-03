#!/bin/bash
#
# Switch the keyboard language.
#
# Usage:
#     language

fcitx5-remote -t
niri msg action switch-layout next
