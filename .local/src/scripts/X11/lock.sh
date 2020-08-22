#!/bin/bash
#
# Locks the screen using slock and a custom lockscreen.
# Suspends the system on lockscreen inactivity after a specified time.

set -o errexit
set -o nounset
set -o pipefail

main() {
    getOptions "${@}"
    if canLock; then
        pamixer --mute
        lock
    fi
}

getOptions() {
    local options="fht"
    f="false"
    t="false"
    m="false"
    while getopts "${options}" flag; do
        case "${flag}" in
            f)
                f="true"
                ;;
            h)
                usage
                exit "0"
                ;;
            t)
                t="true"
                ;;
            *)
                error "Error: Unsupported option"
                usage
                exit "1"
                ;;
        esac
    done

    if getMute; then
        m="true"
    fi
}

usage() {
    echo "Locks the screen using slock and a custom lockscreen"
    echo "Options:"
    echo "    -f: Force locking over videos"
    echo "    -h: Help menu"
    echo "    -t: Translucent background"
}

error() {
    local errorMessage="${*}"
    echo "${errorMessage}" 1>&2
}

canLock() {
    getFlag "${f}" || ! isVideoPlaying
}

getFlag() {
    local flag="${1}"
    [[ "${flag}" == "true" ]]
}

isVideoPlaying() {
    local drivers="/proc/asound/card*/pcm*/sub*/status"
    cat ${drivers} | grep --quiet "state: RUNNING"
}

lock() {
    local lockscreen
    lockscreen="$(initLockscreen)"
    local locker="slock -i ${lockscreen}"
    configureLock "${lockscreen}"
    if lockFileDescriptorIsOpen; then
        ${locker} {XSS_SLEEP_LOCK_FD}<&- &
        closeLockFileDescriptor
    else
        ${locker} &
    fi
    wait "${!}"
}

initLockscreen() {
    mktemp "/tmp/lockscreen.XXXXXXX.png"
}

configureLock() {
    local lockscreen="${1}"
    setTraps "${lockscreen}"
    startSuspendTimer
    createLockscreen "${lockscreen}"
}

setTraps() {
    local lockscreen="${1}"
    trap "cleanup ${lockscreen}" "EXIT"
}

cleanup() {
    local lockscreen="${1}"
    if regularFileExists "${lockscreen}"; then
        rm "${lockscreen}"
    fi
    if [[ "${m}" == "false" ]]; then
        pamixer --unmute
    fi
    stopSuspendTimer
}

regularFileExists() {
    local file="${1}"
    [[ -f "$file" ]]
}

stopSuspendTimer() {
    kill "%%" > /dev/null
}

getMute() {
    pamixer --get-mute > /dev/null
}

startSuspendTimer() {
    local timeInMinutes=10
    local suspender="systemctl suspend"
    xautolock -time "${timeInMinutes}" -locker "${suspender}" &
}

createLockscreen() {
    local lockscreen="${1}"
    if getFlag "$t"; then
        createTranslucentLockscreen "${lockscreen}"
    else
        createDefaultLockscreen "${lockscreen}"
    fi
    addLockIcon "${lockscreen}"
}

createTranslucentLockscreen() {
    local lockscreen="${1}"
    createScreenshot "${lockscreen}"
    blurImage "${lockscreen}"
}

createScreenshot() {
    local lockscreen="${1}"
    maim "${lockscreen}"
}

blurImage() {
    local lockscreen="${1}"
    convert "${lockscreen}" -filter Gaussian -thumbnail 20% -sample 500% \
            "${lockscreen}"
}

createDefaultLockscreen() {
    local lockscreen="${1}"
    local defaultLockscreen="${HOME}/.local/share/backgrounds/lockscreens/lockscreen.png"
    cp "${defaultLockscreen}" "${lockscreen}"
}

addLockIcon() {
    local lockscreen="${1}"
    local lockIcon="${HOME}/.local/share/backgrounds/lockscreens/lock.png"
    convert "${lockscreen}" "${lockIcon}" -gravity "center" \
            -composite "${lockscreen}"
}

lockFileDescriptorIsOpen() {
    fileExists "/dev/fd/${XSS_SLEEP_LOCK_FD:--1}"
}

fileExists() {
    local file="${1}"
    [[ -e "${file}" ]]
}

closeLockFileDescriptor() {
    exec {XSS_SLEEP_LOCK_FD}<&-
}

main "${@}"
