#!/bin/bash
#
# Displays a dmenu selection for exiting the display manager.

set -o errexit
set -o nounset
set -o pipefail

main() {
    case "$(getSelection)" in
        "quit")
            quit
            ;;
        "reboot")
            reboot
            ;;
        "shutdown")
            shutdown
            ;;
        "standby")
            standby
            ;;
        "hibernate")
            hibernate
            ;;
    esac
}

getSelection() {
    getOptions | dmenu -i -l "$(getOptionsLength)"
}

getOptions() {
    local -a options=("quit" "reboot" "shutdown" "standby" "hibernate")
    printf "%s\n" "${options[@]}"
}

getOptionsLength() {
    getOptions | wc --lines
}

quit() {
    kill "$(pidof "dwm")"
}

reboot() {
    systemctl reboot
}

shutdown() {
    systemctl poweroff
}

standby() {
    systemctl suspend
}

hibernate() {
    systemctl hibernate
}

main
