#!/bin/bash

# An i3blocks mount output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Notifications
# Uses the same parameters as the dunstify command
notify() {
  dunstify -h string:x-canonical-private-synchronous:"battery" "$@"
}

storageDevices="$(lsblk -o "NAME,SIZE,TYPE,TRAN" | grep "usb" | grep "disk" \
    | awk '{
  if (system("mount -l | grep -q /mnt/" $1)) {
    printf "Mount 📵 "
  } else {
    printf "Unmount 💽 "
  }
  print "/dev/" $1 " (" $2 ")";
}')"

mobileDevices="$(simple-mtpfs -l | awk '{
  if (system("mount -l | grep -q /mnt/" $2)) {
    printf "Mount 📵 "
  } else {
    printf "Unmount 📱 "
  }
  print $2
}')"

# device =[#][type][action][path][(size)]. Ex.:
# 1: 💽 Mount /dev/sda (32G)
device="$(echo -e "$storageDevices\n$mobileDevices")"
print="false"
output="\n"

# If a device is mounted show icon
while read -r line; do
  if [[ "$(echo -e "$line" | awk '{print $1}')" == "Unmount" ]]; then
    print="true"
  fi
done <<< "$device"

if [[ ! -z "$device" && "$print" == "true" ]]; then
  # Long text
  echo "📱"
  # Short text
  echo "📱"

  # Mouse listener
  case "$BLOCK_BUTTON" in
    1) # Left click
      sudo "$HOME/scripts/dmenu/mount.sh"
      ;;
    3) # Right click
      output+="Mounted:\n"
      while read -r line; do
        if [[ "$(echo -e "$line" | awk '{print $1}')" == "Unmount" ]]; then
          output+="$(echo "$line\n" | cut -d " " -f 2-)"
        fi
      done <<< "$device"
      output+="\nUnmounted:\n"
      while read -r line; do
        if [[ "$(echo -e "$line" | awk '{print $1}')" == "Mount" ]]; then
          output+="$(echo "$line\n" | cut -d " " -f 2-)"
        fi
      done <<< "$device"
      notify "Devices" "$output"
      ;;
  esac
fi
