#!/bin/sh

# A dmenu device mount script
# Gives a dmenu prompt to mount or unmount loaded devices
# Requires root access

# Notifications
# Uses the same parameters as the dunstify command
notify() {
  local USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
  $USER_HOME/scripts/misc/dunstify-as-root.sh "$@"
}

# Check for root access
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root" 
   exit 1
fi

storagedevices="$(lsblk -o "NAME,SIZE,TYPE,TRAN" | grep "usb" | grep "disk" \
  | awk '{
    printf NR ": 💽 "
    if (system("mount -l | grep -q /mnt/" $1)) {
      printf "Mount "
    } else {
      printf "Unmount "
    }
    print "/dev/" $1 " (" $2 ")";
  }'
)"

mobiledevices="$(simple-mtpfs -l | awk '{
  printf $1 " 📱 "
  if (system("mount -l | grep -q /mnt/" $2)) {
    printf "Mount "
  } else {
    printf "Unmount "
  }
  print $2
}')"

# device =[#][type][action][path][(size)]. Ex.:
# 1: 💽 Mount /dev/sda (32G)
device="$(echo -e "\n$storagedevices\n$mobiledevices" \
  | dmenu -i -p "Select device to mount or unmount")"
number="$(echo -e $device | awk '{print $1}')"
type="$(echo -e $device | awk '{print $2}')"
action="$(echo -e $device | awk '{print $3}')"
path="$(echo -e $device | awk '{print $4}')"
name="${path##*/}"

if [ "$action" = "Mount" ]; then
  mkdir -p "/mnt/$name"
  if [ "$type" = "💽" ]; then
    mount "/dev/$name" "/mnt/$name" && notify "Mounted" "💽 $path"
  elif [ "$type" = "📱" ]; then
    simple-mtpfs --device $number "/mnt/$name" && notify "Mounted" "📱 $path"
  fi
elif [ "$action" = "Unmount" ]; then
  fusermount -u "/mnt/$name" && notify "Unmounted" "📵 $path"
  rmdir "/mnt/$name"
fi
