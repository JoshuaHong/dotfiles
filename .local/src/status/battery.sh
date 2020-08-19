#!/bin/bash
#
# Displays the battery status.

set -o errexit
set -o nounset
set -o pipefail

main() {
    printBattery
}

printBattery() {
    case "$(getStatus)" in
        "Discharging")
            echo "🔋$(getCapacity)%"
            ;;
        "Charging")
            echo "🔌$(getCapacity)%"
            ;;
        "Full")
            echo "✅$(getCapacity)%"
            ;;
        *)
            echo "❓$(getCapacity)%"
            ;;
    esac
}

getStatus() {
    echo "$(< /sys/class/power_supply/BAT0/status)"
}

getCapacity() {
    echo "$(< /sys/class/power_supply/BAT0/capacity)"
}

main
