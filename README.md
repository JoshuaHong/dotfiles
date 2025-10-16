<div align = center>

# Dotfiles
The Arch Linux environment.
</div>

<br>

# Programs
* Operating system: [Arch Linux](https://www.archlinux.org)
    > Provides more simplicity and configurability than any other distribution.

<br>

# Pre-installation

### Install the ISO
* [Download](https://archlinux.org/download) the latest <code>.iso</code> file and the respective <code>.iso.sig</code> PGP signature.
* Fetch the signing key: <code>gpg --auto-key-locate clear,wkd -v --locate-external-key pierre@archlinux.org</code>
* Verify the signature: <code>gpg --verify archlinux-x86_64.iso.sig archlinux-x86_64.iso</code>
* Install the ISO to a drive: <code>dd if=archlinux-x86_64.iso of=/dev/<code><var>DRIVE</var></code> bs=4096 status=progress && sync</code>

### Boot the installation medium
* Disable secure boot
    > 📝 **Note**: Arch Linux does not support secure boot. Secure boot can be set up after installation.
* Use UEFI boot mode
    > 📝 **Note**: UEFI is the newest standard, and most modern hardware does not support legacy BIOS boot.

<br>

# Packages
List all explicitly installed packages that are not direct dependencies (includes optional dependencies): <code>pacman -Qentt</code>

Count: 0

| Package | Justification |
| ------- | ------------- |

\* AUR package
