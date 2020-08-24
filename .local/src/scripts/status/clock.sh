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
    echo " $(getIcon)$(getTime)"
}

getIcon() {
    case "$(getHour)" in
        "01")
            if isHalfPast "$(getMinute)"; then
                echo "🕜"
            else
                echo "🕐"
            fi
            ;;
        "02")
            if isHalfPast "$(getMinute)"; then
                echo "🕝"
            else
                echo "🕑"
            fi
            ;;
        "03")
            if isHalfPast "$(getMinute)"; then
                echo "🕞"
            else
                echo "🕒"
            fi
            ;;
        "04")
            if isHalfPast "$(getMinute)"; then
                echo "🕟"
            else
                echo "🕓"
            fi
            ;;
        "05")
            if isHalfPast "$(getMinute)"; then
                echo "🕠"
            else
                echo "🕔"
            fi
            ;;
        "06")
            if isHalfPast "$(getMinute)"; then
                echo "🕡"
            else
                echo "🕕"
            fi
            ;;
        "07")
            if isHalfPast "$(getMinute)"; then
                echo "🕢"
            else
                echo "🕖"
            fi
            ;;
        "08")
            if isHalfPast "$(getMinute)"; then
                echo "🕣"
            else
                echo "🕗"
            fi
            ;;
        "09")
            if isHalfPast "$(getMinute)"; then
                echo "🕤"
            else
                echo "🕘"
            fi
            ;;
        "10")
            if isHalfPast "$(getMinute)"; then
                echo "🕥"
            else
                echo "🕙"
            fi
            ;;
        "11")
            if isHalfPast "$(getMinute)"; then
                echo "🕦"
            else
                echo "🕚"
            fi
            ;;
        "12")
            if isHalfPast "$(getMinute)"; then
                echo "🕧"
            else
                echo "🕛"
            fi
            ;;
        *)
            echo "🕛"
            ;;
    esac
}

getHour() {
    date "+%I"
}

isHalfPast() {
    local minute="${1}"
    local halfHour=30
    [[ "${minute}" -ge "${halfHour}" ]]
}

getMinute() {
    date "+%M"
}

getTime() {
    date "+%R"
}

main
