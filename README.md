# Dotfiles
Setup for the Arch Linux environment.

## Pre-installation

### BIOS configuration
* Use UEFI boot mode
* Disable secure boot

### Connect to the internet
* Use iwd: `iwctl station <device> connect <SSID>`
    * To find the device run: `iwctl device list`
    * To find the SSID run: `iwctl station <device> get-networks`

### Partition the disks
* Use fdisk: `fdisk /dev/nvme0n1`
* Delete all partitions
* Create a new empty GPT partition table
* Create a 550M EFI System
* Create a 4G Linux Swap
* Create a 30G Linux root (x86-64)
* Create the rest for Linux home

### Format the partitions
* Format the boot partition: `mkfs.fat -F 32 /dev/nvme0n1p1`
* Create the swap partition: `mkswap /dev/nvme0n1p2`
* Format the root partition: `mkfs.ext4 /dev/nvme0n1p3`
* Format the home partition: `mkfs.ext4 /dev/nvme0n1p4`

### Mount the file systems
* Mount the root partition: `mount /dev/nvme0n1p3 /mnt`
* Mount the boot partition: `mount --mkdir /dev/nvme0n1p1 /mnt/boot`
* Enable the swap volume: `swapon /dev/nvme0n1p2`

## Installation

### Install essential packages
* Install the microcode, a wireless daemon, and a text editor: `pacman -S intel-ucode iwd neovim`
* Enable iwd: `systemctl enable --now iwd.service systemd-resolved.service`
* Create the iwd configuration file `/etc/iwd/main.conf`:
    ```
    [General]
    EnableNetworkConfiguration=true

    [Network]
    EnableIPv6=true
    ```

### Boot loader
* Install systemd-boot: `bootctl install`
* Edit the loader configuration file `/boot/loader/loader.conf`:
    ```
    default arch.conf
    ```
* Create the Arch configuration file `/boot/loader/entries/arch.conf`:
    ```
    title   Arch Linux
    linux   /vmlinuz-linux
    initrd  /intel-ucode.img
    initrd  /initramfs-linux.img
    options root=UUID=<UUID> rw
    ```
    \* To find the UUID of the **root** partition in vim run: `:r! blkid`

* Create a Pacman hook for automatic updates in `/etc/pacman.d/hooks/100-systemd-boot.hook`:
    ```
    [Trigger]
    Type = Package
    Operation = Upgrade
    Target = systemd

    [Action]
    Description = Gracefully upgrading systemd-boot...
    When = PostTransaction
    Exec = /usr/bin/systemctl restart systemd-boot-update.service
    ```

## Post-installation

### Users and groups
* Add a new user: `useradd -m -G wheel josh`
    * `-m` creates the user's home directory
    * `-G` adds the user to the group
* Add a password: `passwd josh`

### Security

#### Privilege elevation
* Install sudo: `pacman -S sudo`
* Create a temporary symlink to use visudo: `ln -s /usr/bin/nvim /usr/bin/vi`
* Open the configuration file: `visudo`
* Allow users in the `wheel` group to use `sudo` without a password by uncommenting the following line:
  ```
  %WHEEL ALL=(ALL) NOPASSWD: ALL
  ```
* Remove the temporary symlink: `rm /usr/bin/vi`

#### Restricting root
* Restrict root login: `passwd --lock root`
* Require a user to be in the `wheel` group to use `su` by uncommenting the following line in `/etc/pam.d/su` and `/etc/pam.d/su-l`:
    ```
    auth required pam_wheel.so use_uid
    ```

#### Denying SSH login
* Install openssh: `pacman -S openssh`
* Deny SSH login by uncommenting `PermitRootLogin` and changing `prohibit-password` to `no` in `/etc/ssh/sshd_config`:
    ```
    PermitRootLogin no
    ```
* Restart the SSH daemon: `systemctl restart sshd.service`

### Package Management

#### Pacman
* Uncomment the following miscellaneous configurations in `/etc/pacman.conf`:
  ```
  Color
  CheckSpace
  VerbosePkgLists
  ParallelDownloads = 5
  ILoveCandy
  ```

#### Mirrors
* Install pacman-contrib: `pacman -S pacman-contrib`
* Back up the mirrorlist: `cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup`
* Uncomment every mirror: `sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup`
* Rank the mirrors: `rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist`
* Create a hook to rank mirrors on update in `/etc/pacman.d/hooks/mirrorupgrade.hook`:
```
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Ranking pacman-mirrorlist by speed
When = PostTransaction
Depends = pacman-contrib
Exec = /bin/sh -c "mv -f /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist.backup && sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup && rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist && sed -i '/^#/d' /etc/pacman.d/mirrorlist"
```

#### Makepkg
* Automatically detect and enable safe architecture-specific optimizations in `/etc/makepkg.conf`:
  * Remove any `-march` and `-mtune` C flags
  * Add the `-march=native` C flag:
    ```
    CFLAGS="-march=native ..."
    ```
  * Uncomment the Rust flags
  * Add the `-C target-cpu=native` Rust flag:
    ```
    RUSTFLAGS="-C opt-level=2 -C target-cpu=native"
    ```
* Use additional parallel compilation in `/etc/makepkg.conf`:
  * Uncomment the Make flags
  * Replace the Make flag `-j2` with `-j$(nproc)`:
    ```
    MAKEFLAGS="-j$(nproc)"
    ```
* Use multiple cores on compression in `/etc/makepkg.conf`:
  * Add `--threads=0` to XZ and Zstandard:
    ```
    COMPRESSXZ=(xz -c -z --threads=0 -)
    COMPRESSZST=(zstd -c -z -q --threads=0 -)
    ```

#### Arch User Repository helpers
* Install base-devel and git: `pacman -S base-devel git`
* Clone Paru: `git clone https://aur.archlinux.org/paru.git`
* Change directories: `cd paru`
* Build Paru: `makepkg -si`
* Change directories: `cd ..`
* Remove the directory: `rm -r paru`
* Uninstall Rust: `pacman -Rns rust`

### Errors

#### tpm tpm0: [Firmware Bug]: TPM interrupt not working
* In the BIOS change Security->TPM Availability from Available to Hidden

#### Screen flashes while booting on TTY
* Add the following to `/etc/mkinitcpio.conf`:
    ```
    MODULES=(i915)
    ```
* Recreate the initramfs image: `mkinitcpio -P`

#### cros-usbpd-charger cros-usbpd-charger.5.auto: Unexpected number of charge port count
* No solution found

### Silence the boot output
* Add the `quiet` kernel parameter in `/boot/loader/entries/arch.conf`:
    ```
    options root=UUID=<UUID> rw quiet
    ```

## Packages
List all installed packages that are not strict dependencies of other packages, and which are not in the `base` or `base-devel` package groups: `comm -23 <(pacman -Qqtt | sort) <({ pacman -Qqg base-devel; echo base; } | sort -u)`:

| Package               | Description                         | Justification                             | Notes                                             |
| --------------------- | ----------------------------------- | ----------------------------------------- | ------------------------------------------------- |
| backlight_control *   | Backlight brightness controller     | Controls the backlight brightness         |                                                   |
| bash-completion       | Completion for Bash                 | Adds additional Bash completion commands  |                                                   |
| firefox               | Web browser                         | Browses the web                           | Select noto-fonts and pipewire-jack dependencies  |
| foot                  | Terminal emulator                   | Runs the terminal                         |                                                   |
| hyprland *            | Wayland compositor                  | Manages windows                           |                                                   |
| intel-ucode           | Intel microcode                     | Updates the firmware for system stability |                                                   |
| iwd                   | Wireless daemon                     | Manages networking                        |                                                   |
| linux                 | Linux kernel                        | Runs the Linux kernel                     |                                                   |
| linux-firmware        | Linux firmware                      | Runs the Linux firmware                   |                                                   |
| man-db                | Man page reader                     | Reads man pages                           |                                                   |
| neovim                | Text editor                         | Edits text                                |                                                   |
| nerd-fonts-noto       | Patched Noto fonts                  | Displays colorless symbols                | Use Noto fonts since Firefox requires it anyway   |
| noto-fonts-emoji      | Font family                         | Displays color emojis                     |                                                   |
| openssh               | Remote login tool with SSH          | Allows remote login with SSH              |                                                   |
| pacman-contrib        | Tools for Pacman systems            | Checks for updates and ranks mirrors      |                                                   |
| paru                  | AUR helper                          | Installs packages from the AUR            |                                                   |
| pipewire-pulse        | Multimedia processor                | Manages audio and video                   | Replaces PulseAudio                               |
| waybar-hyprland-git * | Wayland bar for Hyprland            | Displays the bar                          | Git version temporarily needed for sort-by-number |
| wbg *                 | Wallpaper application               | Sets the background image                 |                                                   |

\* AUR packages
