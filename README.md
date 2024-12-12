<div align = center>

# Dotfiles
![screenshot](https://github.com/JoshuaHong/dotfiles/assets/35504995/2827b4a2-c767-427b-be73-fcfefdacefcb)
The Gentoo Linux environment.
</div>

<br>

# Programs
* Operating system: [Gentoo Linux](https://www.gentoo.org)
  > A highly flexible, source-based Linux distribution. 

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
* Update the make configuration file: <code>[/mnt/gentoo/etc/portage/make.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/portage/make.conf)</code>
  > 💡 **Tip:** Alternatively, download the file directly: <code>wget https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/portage/make.conf</code>.
* Install the ebuild repository: <code>emerge-webrsync</code>
* Update the make configuration mirrors: <code>emerge --ask --oneshot --verbose app-portage/mirrorselect && mirrorselect --blocksize 10 --servers 5</code>
* Add the default mirrors to the end of the list of mirrors: <code>/etc/portage/make.conf</code>
  > 💡 **Tip:** The default mirrors can be found by running: <code>grep "GENTOO_MIRRORS" /usr/share/portage/config/make.globals</code>.
* Update the make configuration file CPU flags: <code>emerge --ask --oneshot --verbose app-portage/cpuid2cpuflags && cpuid2cpuflags >> /etc/portage/make.conf</code>
* Format the make configuration file with the new CPU flags: <code>/etc/portage/make.conf</code>
* Remove the make configuration file backup: <code>rm /etc/portage/make.conf.backup</code>
* Sync the ebuild repository: <code>emerge --sync</code>
* Read the news: <code>eselect news read | less</code>
* Purge the news: <code>eselect news purge</code>
* Verify the profile: <code>eselect profile list</code>
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
* Accept required licenses: <code>[/etc/portage/package.license](https://raw.githubusercontent.com/JoshuaHong/dotfiles/master/etc/portage/package.license)</code>
  > 📝 **Note:** This is required to install the following packages.
* Install the Linux firmware: <code>emerge --ask sys-kernel/linux-firmware</code>
* Install the audio firmware: <code>emerge --ask sys-firmware/sof-firmware</code>
* Install the microcode: <code>emerge --ask sys-firmware/intel-microcode</code>
* Set up the EFI directory: <code>mkdir -p /efi/EFI/Gentoo</code>
* Install the kernel installer: <code>emerge --ask sys-kernel/installkernel</code>
* Install the kernel: <code>emerge --ask sys-kernel/gentoo-kernel-bin</code>
* Clean up packages: <code>emerge --depclean</code>
* Clean up old kernel versions: <code>emerge --prune sys-kernel/gentoo-kernel-bin</code>
* Rebuild the kernel modules: <code>emerge --ask @module-rebuild</code>
* Rebuild the initramfs: <code>emerge --config sys-kernel/gentoo-kernel-bin</code>
* Install the kernel sources: <code>emerge --ask sys-kernel/gentoo-sources</code>
* List symlink targets: <code>eselect kernel list</code>
* Create the symlink: <code>eselect kernel set <var>#</var></code>
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
* Install a file indexer: <code>emerge --ask sys-apps/mlocate && mlocate</code>
* Configure the ssh daemon: <code>rc-update add sshd default</code>
* Install a shell completion tool: <code>emerge --ask app-shells/bash-completion</code>
* Install a time synchronizaiton tool: <code>emerge --ask net-misc/chrony && rc-update add chronyd default</code>
* Install filesystem tools: <code>emerge --ask sys-fs/xfsprogs && emerge --ask sys-block/io-scheduler-udev-rules</code>
* Install a wireless daemon: <code>emerge --ask net-misc/dhcpcd && emerge --ask net-wireless/iwd</code>

TODO HERE - see if we need to update /etc/package.use/installkernel -systemd
update the below to use EFI/Gentoo instaed of efi/gentoo

### Configure the boot loader
* Install a boot manager: <code>emerge --ask sys-boot/efibootmgr</code>
  > 📝 **Note:** Use EFISTUB to boot the kernel directly without a bootloader.
* Copy the kernel: <code>mkdir --parents /efi/efi/gentoo/ && cp /boot/vmlinuz-<code><var>VERSION</var></code>-gentoo-dist /efi/efi/gentoo/bzImage.efi</code>
* Copy the initramfs: <code>cp /usr/src/linux-<code><var>VERSION</var></code>-gentoo-dist/arch/x86/boot/initrd /efi/efi/gentoo/initrd</code>
* Create a boot entry with hibernation on the swap partition: <code>efibootmgr --create --disk /dev/<code><var>DISK_NAME</var></code> --part <code><var>BOOT_PARTITION_NUMBER</var></code> --label "Gentoo Linux" --loader "\\efi\\gentoo\\bzImage.efi" --unicode 'root=UUID=<code><var>ROOT_UUID</var></code> resume=UUID=<code><var>SWAP_UUID</var></code> rw initrd=\\boot\\intel-uc.img initrd=\\efi\\gentoo\\initrd'</code>
  > 📝 **Note:** If, for example, the boot partition is on <code>/dev/nvme0n1p1</code>, then the <code>DISK_NAME</code> is <code>nvme0n1</code> and the <code>BOOT_PARTITION_NUMBER</code> is <code>1</code>. \
  > 💡 **Tip:** To find the UUIDs, run <code>lsblk -f</code>.
* Verify the entry was added properly: <code>efibootmgr --unicode</code>
* Set the boot order: <code>efibootmgr --bootorder <var>####</var>,<var>####</var> --unicode</code>

### Install essential packages
*  Install the base system: <code>basestrap /mnt base base-devel dinit elogind-dinit linux linux-firmware</code>

### Generate the fstab
* Generate the fstab file: <code>fstabgen -U /mnt >> /mnt/etc/fstab</code>
  > 📝 **Note:** Using <code>-U</code> for UUIDs instaed of <code>-L</code> for labels is safer.

### Enter the system
* Change root into the system: <code>artix-chroot /mnt</code>

### Configure the system clock
* Set the time zone: <code>ln -sf /usr/share/zoneinfo/<code><var>REGION</var></code>/<code><var>CITY</var></code> /etc/localtime</code>
* Set the hardware clock: <code>hwclock --systohc</code>

### Configure the localization
* Install a text editor: <code>sudo pacman -S neovim</code>
* Uncomment <code>en_US.UTF-8 UTF-8</code> and other needed locales in <code>/etc/locale.gen</code>
* Generate the locales: <code>locale-gen</code>
* Create the locale configuration file <code>/etc/locale.conf</code>:
  <pre>
  LANG=en_US.UTF-8
  </pre>

### Configure the boot loader
* Install a boot manager and the microcode: <code>pacman -S efibootmgr intel-ucode</code>
  > 📝 **Note:** Use EFISTUB to boot the kernel directly without a bootloader. \
  > 📝 **Note:** The microcode package depends on the CPU manufacturer.
* Create a boot entry with hibernation on the swap partition: <code>efibootmgr --create --disk /dev/<code><var>DISK_NAME</var></code> --part <code><var>BOOT_PARTITION_NUMBER</var></code> --label "Artix Linux" --loader /vmlinuz-linux --unicode 'root=UUID=<code><var>ROOT_UUID</var></code> resume=UUID=<code><var>SWAP_UUID</var></code> rw quiet initrd=\\<code><var>CPU_MANUFACTURER</var></code>-ucode.img initrd=\initramfs-linux.img'</code>
  > 📝 **Note:** For example, if the boot partition is on <code>/dev/nvme0n1p1</code>, then the <code>DISK_NAME</code> is <code>nvme0n1</code> and the <code>PARTITION_NUMBER</code> is <code>1</code>. \
  > 📝 **Note:** Replace <code>CPU_MANUFACTURER</code> with <code>amd</code> or <code>intel</code>. \
  > 💡 **Tip:** To find the UUIDs, run <code>lsblk -f</code>.
* Verify the entry was added properly: <code>efibootmgr --unicode</code>
* Set the boot order: <code>efibootmgr --bootorder <var>####</var>,<var>####</var> --unicode</code>

### Configure users
* Set the root password: <code>passwd</code>
* Add a new user: <code>useradd -m -G wheel <code><var>USERNAME</var></code></code>
  > 📝 **Note:** <code>-m</code> creates the user's home directory, <code>-G</code> adds the user to the group
* Assign a password: <code>passwd <code><var>USERNAME</var></code></code>

### Configure networking
* Create the hostname file <code>/etc/hostname</code>:
  <pre>
  <code><var>HOSTNAME</var></code>
  </pre>
  > 💡 **Tip:** Choose a hostname to identify the machine on a network.
* Add the entry to the hosts file <code>/etc/hosts</code>:
  <pre>
  127.0.0.1        localhost
  ::1              localhost
  127.0.1.1        <var>HOSTNAME</var>.localdomain  <var>HOSTNAME</var>
  </pre>
* Install a wireless daemon and a DNS framework: <code>pacman -S iwd-dinit openresolv</code>
  > 📝 **Note:** Iwd manages networking without a network manager, and aims to replace wpa_supplicant.
* Create the iwd configuration file <code>/etc/iwd/main.conf</code>:
  <pre>
  [General]
  EnableNetworkConfiguration=true

  [Network]
  EnableIPv6=true
  NameResolvingService=resolvconf
  </pre>
  > 📝 **Note:** <code>EnableNetworkConfiguration</code> allows networking through iwd directly without a network manager. \
  > 📝 **Note:** <code>resolvconf</code> is required using <code>openresolv</code> for DNS management and networking.
* Enable the networking service: <code>ln -s /etc/dinit.d/iwd /etc/dinit.d/boot.d</code>

### Reboot
* Exit the chroot environment: <code>exit</code>
* Unmount the drive: <code>umount -R /mnt</code>
* Reboot the system: <code>reboot</code>

<br>

# Post-installation

### Connect to the internet
* Connect to the internet: <code>iwctl station <code><var>DEVICE</var></code> connect <code><var>SSID</var></code></code>
  > 💡 **Tip:** List all device names: <code>iwctl device list</code> \
  > 💡 **Tip:** List all SSIDs: <code>iwctl station <code><var>DEVICE</var></code> get-networks</code>
* Verify the connection: <code>ping artixlinux.org</code>

### Enable privilege elevation
* Temporarily set the editor to use visudo: <code>export VISUAL=nvim</code>
* Open the configuration file: <code>visudo</code>
* Allow users in the <code>wheel</code> group to use <code>sudo</code> without a password by uncommenting the following line:
  <pre>
  %wheel ALL=(ALL:ALL) NOPASSWD: ALL
  </pre>

### Restrict root
* Restrict root login: <code>passwd --lock root</code>
* Require a user to be in the <code>wheel</code> group to use <code>su</code> by uncommenting the following line in <code>/etc/pam.d/su</code> and <code>/etc/pam.d/su-l</code>:
  <pre>
  auth required pam_wheel.so use_uid
  </pre>

### Deny SSH login
* Install openssh: <code>pacman -S openssh-dinit</code>
* Deny SSH login by uncommenting <code>PermitRootLogin</code> and changing <code>prohibit-password</code> to <code>no</code> in <code>/etc/ssh/sshd_config</code>:
  <pre>
  PermitRootLogin no
  </pre>

### Configure Pacman
* Uncomment the following configurations in <code>/etc/pacman.conf</code>:
  <pre>
  CheckSpace
  Color
  ILoveCandy
  ParallelDownloads = 5
  VerbosePkgLists
  </pre>

### Configure mirrors
* Install artix-archlinux-support for Arch Linux packages: <code>pacman -S artix-archlinux-support</code>
  > 📝 **Note:** This is needed because many common Arch Linux packages are missing from the Artix Linux repositories.
* Add the Arch Linux mirrorlists **after** the Artix Linux mirrorlists in <code>/etc/pacman.conf</code>:
  <pre>
  [extra]
  Include = /etc/pacman.d/mirrorlist-arch

  [multilib]
  Include = /etc/pacman.d/mirrorlist-arch
  </pre>
  > ❗ **Important:** The Arch mirrorlists must be listed after the Artix mirrorlists so that the Artix packages take precedence.
* Update the keyring for Arch packages: <code>pacman-key --populate archlinux</code>
* Install pacman-contrib for pacman tools: <code>pacman -S pacman-contrib</code>
* Back up the mirrorlists: <code>cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup && cp /etc/pacman.d/mirrorlist-arch /etc/pacman.d/mirrorlist-arch.backup</code>
* Create a hook to rank mirrors on artix-mirrorlist update in <code>/etc/pacman.d/hooks/rankmirrors.hook</code>:
  <pre>
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = artix-mirrorlist

  [Action]
  Description = Ranking artix-mirrorlist by speed
  When = PostTransaction
  Depends = pacman-contrib
  Exec = /bin/sh -c "cp -f /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist.backup && sed -i -e 's/^#Server/Server/' -e '/^#/d' /etc/pacman.d/mirrorlist.pacnew && rankmirrors /etc/pacman.d/mirrorlist.pacnew > /etc/pacman.d/mirrorlist && rm /etc/pacman.d/mirrorlist.pacnew"
  </pre>
* Create a hook to rank mirrors on archlinux-mirrorlist update in <code>/etc/pacman.d/hooks/rankmirrors-arch.hook</code>:
  <pre>
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = archlinux-mirrorlist

  [Action]
  Description = Ranking archlinux-mirrorlist by speed
  When = PostTransaction
  Depends = pacman-contrib
  Exec = /bin/sh -c "cp -f /etc/pacman.d/mirrorlist-arch.pacnew /etc/pacman.d/mirrorlist-arch.backup && sed -i -e 's/^#Server/Server/' -e '/^#/d' /etc/pacman.d/mirrorlist-arch.pacnew && rankmirrors /etc/pacman.d/mirrorlist-arch.pacnew > /etc/pacman.d/mirrorlist-arch && rm /etc/pacman.d/mirrorlist-arch.pacnew"
  </pre>
* Sync the Arch Linux repositories: <code>pacman -Syu</code>

### Configure Makepkg
* Automatically detect and enable safe architecture-specific optimizations in <code>/etc/makepkg.conf</code>:
  * Remove any <code>-march</code> and <code>-mtune</code> C flags
  * Add the <code>-march=native</code> C flag:
    <pre>
    CFLAGS="-march=native ..."
    </pre>
  * Uncomment the Rust flags
  * Add the <code>-C target-cpu=native</code> Rust flag:
    <pre>
    RUSTFLAGS="-C opt-level=2 -C target-cpu=native"
    </pre>
  * Uncomment the Make flags
  * Use parallel compilation by replacing the Make flag <code>-j2</code> with <code>-j$(nproc)</code>:
    <pre>
    MAKEFLAGS="-j$(nproc)"
    </pre>
  * Use multiple cores on compression by adding <code>--threads=0</code> to XZ and Zstandard:
    <pre>
    COMPRESSXZ=(xz -c -z --threads=0 -)
    COMPRESSZST=(zstd -c -z -q --threads=0 -)
    </pre>

### Install an AUR helper
* Install Git: <code>pacman -S git-dinit</code>
* Clone Paru: <code>git clone https://aur.archlinux.org/paru.git</code>
  > 📝 **Note:** Paru is the latest AUR helper and a Rust rewrite of Yay.
* Build Paru: <code>cd paru && makepkg -sir</code>
  > 📝 **Note:** Select the rust cargo dependency.
* Remove the directory: <code>cd .. && rm -rf paru</code>

### Import GPG keys
* Temporarily export the XDG_DATA_HOME environment variable: <code>export XDG_DATA_HOME=~/.local/share</code>
* Create the GnuPG directory: <code>mkdir --parents ${XDG_DATA_HOME}/gnupg/private-keys-v1.d</code>
* Import the public key: <code>gpg --import <code><var>PUBLIC-KEY</var></code>.gpg</code>
* Import the private key: <code>gpg --import <code><var>PRIVATE-KEY</var></code>.gpg</code>
* Import the revocation certificate: <code>cp <code><var>REVOCATION-CERTIFICATE</var></code>.gpg ${XDG_DATA_HOME}/gnupg/openpgp-revocs.d</code>
* Set the permissions: <code>chown -R $(whoami) ${XDG_DATA_HOME}/gnupg && chmod 700 ${XDG_DATA_HOME}/gnupg && chmod 600 ${XDG_DATA_HOME}/gnupg/* && chmod 700 ${XDG_DATA_HOME}/gnupg/*.d</code>
  > 📝 **Note:** This is needed for the gpg warning: <code>WARNING: unsafe permissions on homedir</code>.

### Install the remaining packages
* Install the remaining packages: <code>paru -S backlight_control foot man-db noto-fonts-emoji pass polkit river ttf-iosevka ttf-material-symbols-git ungoogled-chromium waylock wbg wl-clipboard yambar</code>
  > 📝 **Note:** Install using the following dependencies: pipewire-jack, wireplumber.
* Clone the configuration files: <code>git clone https://github.com/JoshuaHong/dotfiles.git && cd dotfiles</code>
* Copy the configuration files: <code>rm ~/.* && cp -r .bash_profile .bashrc .config downloads .local .profile .trash ~ && rm ~/downloads/.gitkeep</code>

### Reboot
* Reboot: <code>reboot</code>

<br>

# Packages
List all installed packages that are not strict dependencies of other packages: <code>pacman -Qtt</code>

| Package                    | Justification                                                                                                          |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| artix-archlinux-support    | Enables installing Arch Linux packages. Many common Arch Linux packages are missing from the Artix Linux repositories. |
| backlight_control *        | Controls the backlight brightness. Extremely minimal and requires no permissions setup like other backlight utilities. |
| base                       | Tools to install Artix Linux.                                                                                          |
| base-devel                 | Tools to build Artix Linux packages.                                                                                   |
| efibootmgr                 | Boots Linux without a bootloader by loading the kernel directly.                                                       |
| foot                       | Terminal emulator. Fast, lightweight, minimalistic, and Wayland native.                                                |
| git-dinit                  | Manages version control.                                                                                               |
| intel-ucode                | Updates the firmware for system stability.                                                                             |
| iwd-dinit                  | Manages networking without a full network manager.                                                                     |
| linux                      | Linux kernel.                                                                                                          |
| linux-firmware             | Linux firmware.                                                                                                        |
| man-db                     | Reads man pages.                                                                                                       |
| neovim                     | Text editor.                                                                                                           |
| noto-fonts-emoji           | Emoji fonts.                                                                                                           |
| openssh                    | Allows remote login with SSH.                                                                                          |
| pacman-contrib             | Checks for updates, ranks mirrors, and manages .pacnew and .pacsave files.                                             |
| paru *                     | Installs packages from the Arch User Repository. The latest AUR helper and Rust rewrite of Yay. Install using rust.    |
| pass                       | Password manager. Simple and secure.                                                                                   |
| polkit                     | Manages elevated permissions to run Wayland.                                                                           |
| river                      | Window manager. Simple and fast tiling Wayland compositor.                                                             |
| ttf-iosevka *              | Typeface family. An aesthetic, open-source, monospace typeface family.                                                 |
| ttf-material-symbols-git * | Emoji symbol outlines.                                                                                                 |
| ungoogled-chromium         | Web browser. A spyware-free chromium engine. Install using pipewire-jack and wireplumber, the latest standards.        |
| waylock                    | Screenlocker. A small and secure screenlocker for Wayland.                                                             |
| wbg *                      | Sets the wallpaper for Wayland. Extremely minimal; does only one thing.                                                |
| wl-clipboard               | Wayland clipboard manager. Used for copying passwords without printing to the terminal.                                |
| yambar *                   | Status panel. Modular, configurable, and lightweight.                                                                  |

\* AUR packages
