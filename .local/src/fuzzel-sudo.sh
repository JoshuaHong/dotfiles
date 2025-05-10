#!/bin/bash
#
# Use Fuzzel to enter sudo passwords.
#
# Usage:
#     export SUDO_ASKPASS=fuzzel-sudo.sh
#     sudo --askpass

fuzzel --dmenu --password --prompt="Password: "
