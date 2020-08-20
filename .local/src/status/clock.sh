#!/bin/bash
#
# Displays the clock time.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printTime
}

printTime() {
    echo " $(getIcon)$(getTime) "
}

getIcon() {
    case "$(getHour)" in
        "01")
            echo "🕐"
            ;;
        "02")
            echo "🕑"
            ;;
        "03")
            echo "🕒"
            ;;
        "04")
            echo "🕓"
            ;;
        "05")
            echo "🕔"
            ;;
        "06")
            echo "🕕"
            ;;
        "07")
            echo "🕖"
            ;;
        "08")
            echo "🕗"
            ;;
        "09")
            echo "🕘"
            ;;
        "10")
            echo "🕙"
            ;;
        "11")
            echo "🕚"
            ;;
        "12")
            echo "🕛"
            ;;
        *)
            echo "🕛"
            ;;
    esac
}

getHour() {
    date "+%I"
}

getTime() {
    date "+%R"
}

main
