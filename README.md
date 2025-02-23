<div align = center>

# Dotfiles
![screenshot](https://github.com/JoshuaHong/dotfiles/assets/35504995/2827b4a2-c767-427b-be73-fcfefdacefcb)
The Gentoo Linux environment.
</div>

<br>

# Programs
* Operating system: [Gentoo Linux](https://www.gentoo.org)
    > A highly flexible, source-based Linux distribution.
* Compositor: [Hyprland](https://hyprland.org)
    > An independent, highly customizable, dynamic tiling Wayland compositor that doesn't sacrifice on its looks. 
* Terminal emulator: [Foot](https://codeberg.org/dnkl/foot)
    > A fast, lightweight and minimalistic Wayland terminal emulator.
* Browser: [Mullvad](https://mullvad.net/en/browser)
    > A privacy-focused browser based on TOR.

<br>

# Installation

### Install the ISO
* [Download](https://distfiles.gentoo.org/releases/amd64/autobuilds/current-install-amd64-minimal/) the latest minimal installation <code>.iso</code> CD and the corresponding <code>.iso.asc</code> PGP signature
    > 📝 **Note:** In Gentoo, the keyword <code>amd64</code> refers to any 64-bit architecture, whether AMD or Intel.
* Fetch the Gentoo Linux Release Engineering [key fingerprint](https://www.gentoo.org/downloads/signatures/): <code>gpg --keyserver hkps://keys.gentoo.org --recv-keys <code><var>KEY_FINGERPRINT</var></code></code>
* Verify the ISO: <code>gpg --verify install-amd64-minimal-<code><var>TIMESTAMP</var></code>.iso.asc install-amd64-minimal-<code><var>TIMESTAMP</var></code>.iso</code>
* Install the ISO to a drive: <code>dd if=install-amd64-minimal-<code><var>TIMESTAMP</var></code>.iso of=/dev/<code><var>DRIVE_NAME</var></code> bs=4096 status=progress && sync</code>
    > 📝 **Note:** <code>dd</code> is the natural tool for working with raw images.

### Boot the installation medium
* Use UEFI boot mode
    > 📝 **Note:** UEFI is the newest standard, and most modern hardware does not support legacy BIOS boot.
* Disable secure boot
    > 📝 **Note:** Sometimes installation images do not support secure boot. Secure boot can be set up after installation.
* Ensure that the boot order prioritizes the external bootable media over the internal disk devices
* Boot into the live environment

### Configure the network
* Disable the shell history: <code>set +o history</code>
    > ⚠️ **Warning:** History is disabled to avoid storing the clear text password in history.
* Connect to the network: <code>wpa_supplicant -i <code><var>DEVICE_NAME</var></code> -c <(wpa_passphrase "<code><var>SSID</var></code>" "<code><var>PASSWORD</var></code>") &</code>
    > 💡 **Tip:** List all device names: <code>ip link</code>.
* Enable the shell history: <code>set -o history</code>
* Verify the connection: <code>ping -c 3 gentoo.org</code>

### Partition the disks
* Use fdisk: <code>fdisk /dev/<code><var>DISK_NAME</var></code></code>
    * Delete all existing partitions and signatures
        > ⚠️ **Warning:** This will wipe out the entire drive.
    * Create a new empty GPT partition table
        > 📝 **Note:** GPT is the latest and recommended standard allowing more partitions and handles larger disk sizes.
    * Create a 550M EFI System
        > 📝 **Note:** The author of gdisk suggests 550M.
    * Create a 30G Linux Swap
        > 📝 **Note:** The rule of thumb is 2xRAM for hibernation.
    * Create a 30G Linux root (x86-64)
        > 📝 **Note:** 15G is the recommended minimum, so 30G should be enough.
    * Create the rest for Linux home

### Format the partitions
* Format the boot partition: <code>mkfs.fat -F 32 /dev/<code><var>BOOT_PARTITION</var></code></code>
    > 📝 **Note:** The EFI system partition must be formatted as FAT32 on UEFI systems.
* Set the boot partition label name: <code>fatlabel /dev/<code><var>BOOT_PARTITION</var></code> BOOT</code>
    > 💡 **Tip:** Assigning labels to partitions helps referring to them later without their numbers. \
    > 📝 **Note:** FAT volume labels are stored in uppercase, and warns that lowercase labels may not work on some systems.
* Create the swap partition: <code>mkswap -L SWAP /dev/<code><var>SWAP_PARTITION</var></code></code>
    > 💡 **Tip:** Any existing swap partitions may need to be removed in advance: <code>swapoff -a</code>.
* Format the root partition: <code>mkfs.xfs -L ROOT /dev/<code><var>ROOT_PARTITION</var></code></code>
    > 📝 **Note:** XFS is the Gentoo recommended all-purpose, all-platform filesystem.
* Format the home partition: <code>mkfs.xfs -L HOME /dev/<code><var>HOME_PARTITION</var></code></code>

### Mount the file systems
* Mount the root partition: <code>mount --mkdir /dev/<code><var>ROOT_PARTITION</var></code> /mnt/gentoo</code>
    > ⚠️ **Warning:** Gentoo mounts the live CD on <code>/mnt/livecd</code>; mounting anything on <code>/mnt</code> itself will break all commands.
* Mount the boot partition: <code>mount --mkdir /dev/<code><var>BOOT_PARTITION</var></code> /mnt/gentoo/efi</code>
* Mount the home partition: <code>mount --mkdir /dev/<code><var>HOME_PARTITION</var></code> /mnt/gentoo/home</code>
* Enable the swap volume: <code>swapon /dev/<code><var>SWAP_PARTITION</var></code></code>

### Install the stage file
* Change directories to the mount point: <code>cd /mnt/gentoo</code>
* Update the system clock: <code>chronyd -q</code>
* [Download](https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-openrc/) the latest stage 3 openrc <code>.tar.xz</code> file and associated <code>.tar.xz.CONTENTS.gz</code>, <code>.tar.xz.DIGESTS</code>, <code>.tar.xz.asc</code>, and <code>.tar.xz.sha256</code> files: <code>wget https\://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-openrc/stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.<code><var>FILE_EXTENSION</var></code></code>
    > 💡 **Tip:** Alternatively, use a command-line browser to install the files: <code>links https\://www.gentoo.org/downloads/</code>. \
    > 💡 **Tip:** If using links, press <code>Esc</code> to open the menu and use <code>File > Save as</code> to download the <code>.tar.xz.asc</code> text file.
* Verify the SHA512 checksum: <code>openssl dgst -r -sha512 stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.tar.xz</code>
* Verify the BLAKE2B512 checksum: <code>openssl dgst -r -blake2b512 stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.tar.xz</code>
* Ensure that the above two hashes match the one in the <code>.tar.xz.DIGESTS</code> file
* Verify the SHA256 hash: <code>sha256sum --check stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.tar.xz.sha256</code>
* Import the PGP keys: <code>gpg --import /usr/share/openpgp-keys/gentoo-release.asc</code>
* Verify the tarball: <code>gpg --verify stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.tar.xz.asc</code>
* Verify the DIGESTS checksum: <code>gpg --verify stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.tar.xz.DIGESTS</code>
* Verify the SHA256 checksum: <code>gpg --verify stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.tar.xz.sha256</code>
* Install the stage file: <code>tar xpvf stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.tar.xz --xattrs-include='\*.\*' --numeric-owner -C /mnt/gentoo</code>
* Remove the stage file and checksums: <code>rm stage3-amd64-openrc-<code><var>TIMESTAMP</var></code>.*</code>

### Mount the filesystems
* Mount /proc: <code>mount --types proc /proc /mnt/gentoo/proc</code>
* Mount /sys: <code>mount --rbind /sys /mnt/gentoo/sys</code>
* Enslave /sys: <code>mount --make-rslave /mnt/gentoo/sys</code>
* Mount /dev: <code>mount --rbind /dev /mnt/gentoo/dev</code>
* Enslave /dev: <code>mount --make-rslave /mnt/gentoo/dev</code>
* Mount /run: <code>mount --bind /run /mnt/gentoo/run</code>
* Enslave /run: <code>mount --make-slave /mnt/gentoo/run</code>

### Enter the new environment
* Copy DNS information: <code>cp --dereference /etc/resolv.conf /mnt/gentoo/etc/</code>
* Change root: <code>chroot /mnt/gentoo /bin/bash</code>
* Source the profile configuration file: <code>source /etc/profile</code>
* Change the primary prompt: <code>export PS1="(chroot) ${PS1}"</code>

### Configure Portage
* Update the make configuration file: <code>[/etc/portage/make.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/portage/make.conf)</code>
    > 💡 **Tip:** Alternatively, download the file directly: <code>wget https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/portage/make.conf</code>.
* Install the ebuild repository: <code>emaint --auto sync</code>
* Update the make configuration mirrors: <code>emerge --ask app-portage/mirrorselect && mirrorselect --blocksize 10 --servers 5</code>
* Add the default mirrors to the end of the list of mirrors: <code>/etc/portage/make.conf</code>
    > 💡 **Tip:** The default mirrors can be found by running: <code>grep "GENTOO_MIRRORS" /usr/share/portage/config/make.globals</code>.
* Update the make configuration file CPU flags: <code>emerge --ask --oneshot app-portage/cpuid2cpuflags && cpuid2cpuflags >> /etc/portage/make.conf</code>
* Format the make configuration file with the new CPU flags: <code>/etc/portage/make.conf</code>
* Remove the make configuration file backup: <code>rm /etc/portage/make.conf.backup</code>
* Read the news: <code>eselect news read | less</code>
* Purge the news: <code>eselect news purge</code>
* Verify the profile: <code>eselect profile list | less</code>
* Change the profile, if necessary: <code>eselect profile set <code><var>PROFILE_NUMBER</var></code></code>
    > ⚠️ **Warning:** The recommended profile is the default profile.
* Set up the necessary keyring for binary package verification: <code>getuto</code>
* Update the @world set: <code>emerge --ask --verbose --update --deep --newuse --getbinpkg @world</code>
* Remove obsolete packages: <code>emerge --ask --depclean</code>

### Configure the time zone and locales
* Set the time zone: <code>[/etc/timezone](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/timezone)</code>
    > 💡 **Tip:** All time zones can be found in <code>/usr/share/zoneinfo</code>.
* Update the locale configuration file: <code>[/etc/locale.gen](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/locale.gen)</code>
* Generate the locales: <code>locale-gen</code>
* Verify the locales are available: <code>locale -a</code>
* List all locales: <code>eselect locale list</code>
* Select the locale to set: <code>eselect locale set <code><var>LOCALE_NUMBER</var></code></code>
    > 📝 **Note:** This sets the <code>LANG</code> variable in <code>/etc/env.d/02locale</code>. This is typically <code>en_US.utf8</code>.
* Reload the environment: <code>env-update && source /etc/profile && export PS1="(chroot) ${PS1}"</code>

### Install the kernel
* Set the kernel installer keywords: <code>[/etc/portage/package.accept_keywords/installkernel](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/portage/package.accept_keywords/installkernel)</code>
* Set the kernel installer USE flags: <code>[/etc/portage/package.use/installkernel](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/portage/package.use/installkernel)</code>
* Accept the intel-microcode license: <code>[/etc/portage/package.license/intel-microcode](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/portage/package.license/intel-microcode)</code>
* Accept the linux-firmware license: <code>[/etc/portage/package.license/linux-firmware](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/portage/package.license/linux-firmware)</code>
    > 📝 **Note:** These are required to install the following packages.
* Install the kernel installer: <code>emerge --ask sys-kernel/installkernel</code>
* Set up the EFI directory: <code>mkdir --parents /efi/EFI/Gentoo</code>
* Update the UEFI configuration file: <code>[/etc/default/uefi-mkconfig](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/default/uefi-mkconfig)</code>
    > 📝 **Note:** This automatically generates a new UEFI configuration file using efibootmgr whenever a new kernel is installed.
* Install the kernel: <code>emerge --ask sys-kernel/gentoo-kernel-bin</code>
* Install the Linux firmware: <code>emerge --ask sys-kernel/linux-firmware</code>
* Install the audio firmware: <code>emerge --ask sys-firmware/sof-firmware</code>
* Install the microcode: <code>emerge --ask sys-firmware/intel-microcode</code>
* Clean up packages: <code>emerge --depclean</code>
* Clean up old kernel versions: <code>emerge --prune sys-kernel/gentoo-kernel-bin</code>
* Rebuild the kernel modules: <code>emerge --ask @module-rebuild</code>
* Rebuild the initramfs: <code>emerge --config sys-kernel/gentoo-kernel-bin</code>
* Install the kernel sources: <code>emerge --ask sys-kernel/gentoo-sources</code>
* List symlink targets: <code>eselect kernel list</code>
* Create the symlink: <code>eselect kernel set <code><var>#</var></code></code>
    > 📝 **Note:** The <code>-dist</code> suffix indicates a distribution kernel.

### Configure the system
* Update the fstab file: <code>[/etc/fstab](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/fstab)</code>
* Set the hostname: <code>[/etc/hostname](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/hostname)</code>
* Configure the network interface: <code>emerge --ask net-misc/dhcpcd && rc-update add dhcpcd default && rc-service dhcpcd start</code>
* Create the hosts file: <code>[/etc/hosts](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/hosts)</code>
* Set the root password: <code>passwd</code>
* Update the OpenRC configuration file: <code>[/etc/rc.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/rc.conf)</code>
* Update the clock configuration file: <code>[/etc/conf.d/hwclock](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/conf.d/hwclock)</code>

### Install system tools
* Install a system logger: <code>emerge --ask app-admin/sysklogd && rc-update add sysklogd default</code>
* Install a cron daemon: <code>emerge --ask sys-process/cronie && rc-update add cronie default</code>
* Install a file indexer: <code>emerge --ask sys-apps/mlocate</code>
* Configure the ssh daemon: <code>rc-update add sshd default</code>
* Install a shell completion tool: <code>emerge --ask app-shells/bash-completion</code>
* Install a time synchronizaiton tool: <code>emerge --ask net-misc/chrony && rc-update add chronyd default</code>
* Install filesystem tools: <code>emerge --ask sys-fs/xfsprogs && emerge --ask sys-block/io-scheduler-udev-rules</code>
* Install a wireless daemon: <code>emerge --ask net-misc/dhcpcd && emerge --ask net-wireless/iwd</code>

### Reboot the system
* Exit the chrooted environment: <code>exit</code>
* Unmount the mounted partitions: <code>cd && umount --lazy /mnt/gentoo/dev && umount --recursive /mnt/gentoo</code>
* Reboot the system: <code>reboot</code>
* Remove the live image

<br>

# Post-installation

### Configure users
* Add a new user: <code>useradd --create-home --groups wheel <code><var>USERNAME</var></code></code>
* Assign a password: <code>passwd <code><var>USERNAME</var></code></code>

### Configure the network
* Enable the wireless daemon: <code>rc-update add iwd default && rc-service iwd start</code>
* Create the configuration directory: <code>mkdir /etc/iwd/</code>
* Update the configuration file: <code>[/etc/iwd/main.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/iwd/main.conf)</code>
* Connect to the internet: <code>iwctl station <code><var>DEVICE</var></code> connect <code><var>SSID</var></code></code>
    > 💡 **Tip:** List all device names: <code>iwctl device list</code> \
    > 💡 **Tip:** List all SSIDs: <code>iwctl station <code><var>DEVICE</var></code> get-networks</code>
* Verify the connection: <code>ping -c 3 gentoo.org</code>

### Configure Portage repositories
* Delete the Portage tree: <code>rm --force --recursive /var/db/repos/gentoo/*</code>
* Configure Portage with Git: <code>[/etc/portage/repos.conf/gentoo.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/portage/repos.conf/gentoo.conf)</code>
* Configure GURU: <code>[/etc/portage/repos.conf/guru.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/portage/repos.conf/guru.conf)</code>
* Sync the repository: <code>emaint --auto sync</code>

### Install remaining packages
* Clone the configuration files: <code>git clone https://github.com/JoshuaHong/dotfiles.git</code>
* Temporarily include hidden files in wildcard expansion: <code>shopt -s dotglob</code>
* Copy the configuration files: <code>rm --force --recursive /home/<code><var>USERNAME</var></code>/* && cp --recursive dotfiles/* /home/<code><var>USERNAME</var></code>/ && cp --recursive dotfiles/etc/portage/package.* /etc/portage/</code>
* Change ownership of files: <code>chown --recursive <code><var>USERNAME</var></code>:<code><var>USERNAME</var></code> /home/<code><var>USERNAME</var></code>/</code>
* Clean the configuration fles: <code>find /home/<code><var>USERNAME</var></code>/ -name "*.gitkeep" -type f -delete && rm --force --recursive /home/<code><var>USERNAME</var></code>/.git/ /home/<code><var>USERNAME</var></code>/etc/ /home/<code><var>USERNAME</var></code>/README.md && rm --force --recursive dotfiles/</code>
* Install the remaining packages: <code>emerge --ask app-admin/sudo app-editors/neovim app-portage/gentoolkit gui-apps/foot gui-wm/hyprland www-client/mullvad-browser-bin</code>
* Remove obsolete packages: <code>emerge --ask --depclean</code>
* Update the eselect editor: <code>eselect editor set nvim</code>

### Enable seat management
* Add the user to the necessary groups: <code>gpasswd --add <code><var>USERNAME</var></code> seat && gpasswd --add <code><var>USERNAME</var></code> video</code>
* Enable the service on startup: <code>rc-update add seatd default && rc-service seatd start</code>

### Enable privilege elevation
* Temporarily set the editor to use visudo: <code>export VISUAL=nvim</code>
* Open the configuration file: <code>visudo</code>
* Allow users in the wheel group to use sudo: <code>[/etc/sudoers](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/sudoers)</code>

### Enable quiet boot
* Clear the terminal before login: <code>[/etc/inittab](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/inittab)</code>

### Disable root login
* Disable SSH root login: <code>[/etc/ssh/sshd_config](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/ssh/sshd_config)</code>
* Disable root login: <code>passwd --lock root</code>

### Reboot the system
* Clean the home directory: <code>rm --force --recursive "${HOME}/*"</code>
* Reboot the system: <code>reboot</code>

<br>

# Packages
List all directly installed packages (22): <code>cat /var/lib/portage/world</code>

| Package                           | Justification                       |
| --------------------------------- | ----------------------------------- |
| app-admin/sudo                    | To enable privilege escalation.     |
| app-admin/sysklogd                | To log system messages.             |
| app-editors/neovim                | To edit text.                       |
| app-portage/gentoolkit            | To manage packages.                 |
| app-portage/mirrorselect          | To update Gentoo source mirrors.    |
| app-shells/bash-completion        | To enable shell completion.         |
| gui-apps/foot                     | To use the terminal.                |
| gui-wm/hyprland                   | To manage windows.                  |
| net-misc/chrony                   | To synchronize the system clock.    |
| net-misc/dhcpcd                   | To enable DHCP.                     |
| net-wireless/iwd                  | To configure networking.            |
| sys-apps/mlocate                  | To index the file system.           |
| sys-block/io-scheduler-udev-rules | To customize kernel schedulers.     |
| sys-firmware/intel-microcode      | To support the Intel CPU.           |
| sys-firmware/sof-firmware         | To enable audio.                    |
| sys-fs/xfsprogs                   | To use XFS filesystem utilities.    |
| sys-kernel/gentoo-kernel-bin      | To use the Gentoo Linux kernel.     |
| sys-kernel/gentoo-sources         | To provide the kernel source files. |
| sys-kernel/installkernel          | To automaticaly install the kernel. |
| sys-kernel/linux-firmware         | To support hardware devices.        |
| sys-process/cronie                | To run scheduled tasks.             |
| www-client/mullvad-browser-bin    | To browse the internet.             |
