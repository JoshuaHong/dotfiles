#!/bin/bash

# A dmenu device mount script
# Gives a dmenu prompt to mount or unmount loaded devices
# Requires root access

# Notifications
# Uses the same parameters as the dunstify command
notify() {
  local USER_HOME
  USER_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
  "$USER_HOME/scripts/misc/dunstify-as-root.sh" "$@"
}

# Check for root access
if [[ "$EUID" -ne 0 ]]; then
   echo "ERROR: This script must be run as root"
   exit 1
fi

storageDevices="$(lsblk -o "NAME,SIZE,TYPE,TRAN" | grep "usb" | grep "disk" \
    | awk '{
  printf NR ": 💽 "
  if (system("mount -l | grep -q /mnt/" $1)) {
    printf "Mount "
  } else {
    printf "Unmount "
  }
  print "/dev/" $1 " (" $2 ")";
}')"

mobileDevices="$(simple-mtpfs -l | awk '{
  printf $1 " 📱 "
  if (system("mount -l | grep -q /mnt/" $2)) {
    printf "Mount "
  } else {
    printf "Unmount "
  }
  print $2
}')"

# device =[#][type][action][path][(size)]
# Ex: 1: 💽 Mount /dev/sda (32G)
if [[ -z "$storageDevices" ]]; then
  device="$(echo -e "\n$mobileDevices" \
      | dmenu -i -p "Select device to mount or unmount")"
else
  device="$(echo -e "\n$storageDevices\n$mobileDevices" \
    | dmenu -i -p "Select device to mount or unmount")"
fi
number="$(echo -e "$device" | awk '{print $1}')"
type="$(echo -e "$device" | awk '{print $2}')"
action="$(echo -e "$device" | awk '{print $3}')"
path="$(echo -e "$device" | awk '{print $4}')"
name="${path##*/}"

if [[ "$action" == "Mount" ]]; then
  mkdir -p "/mnt/$name"
  if [[ "$type" == "💽" ]]; then
    if mount "/dev/$name" "/mnt/$name"; then
      notify "Mounted" "💽 $path"
      pkill -SIGRTMIN+12 i3blocks
    else
      notify "Mounting Failed" "❌ $path"
    fi
  elif [[ "$type" == "📱" ]]; then
    if simple-mtpfs --device "$number" "/mnt/$name"; then
      notify "Mounted" "📱 $path"
      pkill -SIGRTMIN+12 i3blocks
    else 
      notify "Mounting Failed" "❌ $path"
    fi
  fi
elif [[ "$action" == "Unmount" ]]; then
  if fusermount -u "/mnt/$name"; then
    notify "Unmounted" "📵 $path";
    rmdir "/mnt/$name"
    pkill -SIGRTMIN+12 i3blocks
  else
    notify "Unmounting Failed" "❌ $path"
  fi
fi
