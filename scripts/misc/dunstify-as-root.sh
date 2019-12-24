#!/bin/bash

# Allows dunstify notifications to display when running as root.
# Requires the same parameters "$@" as the dunstify command.

# Note: While this script can be executed by all users,
# running any script as root changes the $HOME path while the script is running.
# If a script is run as root and that script executes this one,
# the "$HOME" path must be addressed appropriately.

# For example:
# # Outputs to standard error.
# # Requires a message "$@" to print.
# echoerr() {
  # echo "$@" 1>&2
# }
# # Check for root access or else "$USER_HOME" will not be correct.
# if [[ $EUID -ne 0 ]]; then
#    echoerr "Error: This script must be run as root."
#    exit 1
# fi
# # Execute dunstify-as-root.sh.
# USER_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
# "$USER_HOME/scripts/misc/dunstify-as-root.sh" --urgency=critical \
#     --expire-time=1000 "Test notification:" "Hello World!"

# Detect the name of the display in use.
display=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"

# Detect the user using such display.
user="$( (who | grep "$display" || who) | awk '{print $1}' | head -n 1)"

# Detect the id of the user.
uid="$(id -u "$user")"

# Send a notification.
# Requires the same parameters "$@" as the dunstify command.
sudo -u "$user" DISPLAY="$display" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" dunstify "$@"
