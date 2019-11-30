#!/bin/bash

exit 0 # Safety on

pacmanPackages="alacritty alsa-utils autoconf automake base bison dmenu dunst \
  fakeroot feh firefox flex gcc gdb grub gvim i3-gaps i3blocks i3lock \
  imagemagick linux linux-firmware make man-db net-tools \
  network-manager-applet noto-fonts-emoji openssh patch picom pkgconf ripgrep \
  scrot which xclip xf86-video-intel xorg-server xorg-xbacklight xorg-xinit \
  xorg-xset valgrind xss-lock"
yayPackages="simple-mtpfs ttf-symbola"

# An installation script for setting up the Arch Linux environment
echo -e "Starting installation...\n"

# Update and install packages
echo "Updating and installing packages..."
echo "Updating pacman packages..."
pacman -Syu
echo "Pacman packages up to date!"
echo "Installing pacman packages..."
pacman -S $pacmanPackages
echo "Pacman packages installed!"
echo "Installing yay..."
git clone https://aur.archlinux.org/yay.git $HOME/programs/ \
  && cd $HOME/programs/yay/ \
  && makepkg -si \
  && cd -
echo "Yay installed!"
echo "Updating yay packages..."
yay -Syu
echo "Yay packages up to date!"
echo "Installing yay packages..."
yay -S $yayPackages
echo "Yay packages installed!"
echo -e "Packages updated and installed!\n"

# Copy files from repo
echo "Copying files from repo..."
echo "Cloning repo..."
git clone https://github.com/JoshuaHong/env.git
echo "Repo cloned!"
echo "Copying files..."
cp -r env/* $HOME
echo "Files copied!"
echo "Removing files..."
rm $HOME/install.sh $HOME/README.md
rm -rf env/
echo "Files removed!"
echo "Files copied from repo!"

# Set up users and groups
echo "Setting up users and groups..."
echo "Creating user..."
useradd -m -g wheel josh
echo "User created!"
echo "Enter a password:"
passwd josh
echo "Password set!"
echo "Giving group sudo access..."
sed -i "s/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/" /etc/sudoers
echo "Sudo access enabled!"
echo -e "Users and groups set up!\n"

# Disable local and ssh root login
echo "Disabling local and root login..."
passwd -l root
echo "Local root login disabled!"
echo "Disabling ssh root login..."
sed -i "s/^#PermitRootLogin Yes/PermitRootLogin No/" /etc/ssh/sshd_config
echo "Ssh root login disabled!"
echo -e "Local and root login disabled!\n"

# Enable parallel compilation and compression
echo "Enabling parallel compilation and compression"
echo "Optimizing compilation..."
sed -i "s/^MAKEFLAGS="-j2"/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf
echo "Compilation optimized!"
echo "Optimizing XYZ compression..."
sed -i "s/^COMPRESSXYZ=(xz -c -z -)/COMPRESSXYZ=(xz -c -z - --threads=0)/" /etc/makepkg.conf
echo "XYZ compression optimized!"
echo "Optimizing ZST compression..."
sed -i "s/^COMPRESSZST=(zstd -c -z -q -)/COMPRESSZST=(zstd -c -z -q - --threads=0)/" /etc/makepkg.conf
echo "ZST compression optmized!"
echo -e "Parallel compilation and compression enabled!\n"

# Hide GRUB menu unless Shift key held down
echo "Hiding GRUB menu unless Shift key held down..."
echo "Adding GRUB hidden menu option..."
echo -e "\n# Hide GRUB menu unless Shift key held down\nGRUB_FORCE_HIDDEN_MENU=\"true\"" >> /etc/default/grub
echo "GRUB hidden menu option added!"
echo "Writing hold Shift script..."
curl "https://gist.githubusercontent.com/anonymous/8eb2019db2e278ba99be/raw/257f15100fd46aeeb8e33a7629b209d0a14b9975/gistfile1.sh" -o "/etc/grub.d/31_hold_shift"
echo "Hold Shift script written!"
echo "Making hold Shift script executable..."
chmod +x "/etc/grubd/31_hold_shift"
echo "Hold Shift script executable!"
echo "Regenerating GRUB configuration..."
grub-mkconfig -o "/boot/grub/grub.cfg"
echo "GRUB configuration regenerated!"
echo -e "GRUB menu hidden unless Shift key held down!\n"

# Set pacman options
echo "Setting pacman options..."
echo "Enabling color..."
sed -i "s/^#Color/Color/" /etc/pacman.conf
echo "Color enabled!"
echo "Enabling total download percentage..."
sed -i "s/^#TotalDownload/TotalDownload/" /etc/pacman.conf
echo "Total download percentage enabled!"
echo "Enabling disk space check before installing..."
sed -i "s/^#CheckSpace/CheckSpace/" /etc/pacman.conf
echo "Disk space check before installing enabled!"
echo "Enabling pacman loading bar..."
sed -i "s/^#ILoveCandy/ILoveCandy/" /etc/pacman.conf
echo "Pacman loading bar enabled!"
echo -e "Pacman options set!\n"

# Install vim plugins
echo "Installing vim plugins..."
vim +PlugUpgrade +PlugInstall +qall
echo -e "Installed vim plugins!\n"

# Done
echo -e "DONE!\n"

# Firefox setup
firefox https://www.privateinternetaccess.com/pages/downloads

# User todos
echo "TODO:"
echo "  1. Install Firefox plugins: ABP, Tabliss"
echo "  2. Enable PIA VPN \"Connect on Launch\""
