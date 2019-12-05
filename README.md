# env
Setup for the Arch Linux environment

### Installation
Copy and run the installation script:
```
cd
curl https://raw.githubusercontent.com/JoshuaHong/env/master/install.sh -o install.sh
chmod +x install.sh
./install.sh && rm -v /install.sh
```

### Useful commands:
| Command        | Description                           |
| -------------- | ------------------------------------- |
| `pacman -Q`    | List installed packages               |
| `pacman -Qi`   | List installed packages with details  |
| `pacman -Qtdq` | List orphans                          |
| `pacman -Qtt`  | List installed non-required packages  |
| `pacman -Rns`  | Uninstall package                     |
| `pacman -S`    | Install package                       |
| `pacman -Sc`   | Remove uninstalled package caches     |
| `pacman -Ss`   | Search for packages in the repository |
| `pacman -Syu`  | Update and upgrade installed packages |

### Packages (46):
| Package                | Description                            | Function                                 |
| ---------------------- | -------------------------------------- | ---------------------------------------- |
| alacritty              | Terminal emulator                      | For running terminal                     |
| alsa-utils             | Audio controls                         | For volume controls                      |
| autoconf               | Automatically configures source code   | For yay (base-devel)                     |
| automake               | Automatically creating make files      | For yay (base-devel)                     |
| base                   | Base packages                          | For arch install                         |
| bison                  | Parser generator                       | For yay (base-devel)                     |
| dmenu                  | Menu bar                               | For searching programs                   |
| dunst                  | Notification daemon                    | For displaying notifications             |
| fakeroot               | Simulating superuser privileges        | For yay (base-devel)                     |
| feh                    | Image viewer                           | For setting wallpaper                    |
| firefox                | Browser                                | For browsing internet                    |
| flex                   | Generates text scanning programs       | For yay (base-devel)                     |
| gcc                    | GNU compiler collection                | For yay (base-devel)                     |
| gdb                    | GNU debugger                           | For debugging                            |
| grub                   | Bootloader                             | For loading Linux kernel                 |
| gvim                   | Text editor                            | For editing text                         |
| i3-gaps                | Window manager                         | For managing windows                     |
| i3blocks               | Status bar                             | For displaying status                    |
| i3lock                 | Lock screen                            | For locking screen                       |
| imagemagick            | Image editor                           | For editing lockscreen                   |
| linux                  | Linux kernel                           | For running Linux                        |
| linux-firmware         | Linux firmware                         | For running Linux                        |
| make                   | GNU make utility                       | For yay (base-devel)                     |
| man-db                 | Man pages                              | For reading program manuals              |
| net-tools              | Networking tools                       | For PIA VPN                              |
| network-manager-applet | System tray for NetworkManager         | For Network Manager applet               |
| noto-fonts-emoji       | Font for emoji symbols                 | For rendering unicode symbols            |
| openssh                | SSH                                    | For SSH                                  |
| patch                  | Patches files                          | For yay (base-devel)                     |
| picom                  | Compositor                             | For transparency                         |
| pkgconf                | Package compiler and linker            | For yay (base-devel)                     |
| reflector              | Retrieve and filter Pacman mirror list | For updating Pacman mirror list          |
| ripgrep                | Grep tool                              | For searching files                      |
| scrot                  | Screen capture                         | For taking screenshotr                   |
| simple-mtpfs *         | Media transfer protocol file system    | For mounting mobile phones               |
| ttf-symbola *          | Font for unicode symbols               | For rendering unicode on dmenu           |
| valgrind               | Memory management tool                 | For catching memory leaks                |
| which                  | Show full path of commands             | For yay (base-devel)                     |
| xclip                  | Manipulates X11 clipboard              | For copying unicode to clipboard         |
| xf86-video-intel       | XOrg video driver                      | For graphics display                     |
| xorg-server            | XOrg package                           | For running X                            |
| xorg-xbacklight        | Screen brightness                      | For brightness controls                  |
| xorg-xinit             | XOrg initialisation                    | For startx                               |
| xorg-xset              | Set lock timeout                       | For setting dim and lock screen timeouts |
| xss-lock               | Use external locker                    | For locking screen                       |
| yay *                  | AUR package manager                    | For installing AUR packages              |

\* = AUR packages
