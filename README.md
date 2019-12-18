# env
Setup for the Arch Linux environment

### Installation
Copy and run the installation script:
```
cd /root
curl https://raw.githubusercontent.com/JoshuaHong/env/master/install.sh -o install.sh
chmod +x install.sh
./install.sh && rm -v install.sh
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

### Packages (48):
| Package                | Description                            | Function                                 |
| ---------------------- | -------------------------------------- | ---------------------------------------- |
| alacritty              | Terminal emulator                      | For running terminal                     |
| alsa-utils             | Audio controls                         | For volume controls                      |
| autoconf               | Automatically configures source code   | For Yay dependency (base-devel)          |
| automake               | Automatically creating make files      | For Yay dependency (base-devel)          |
| base                   | Base packages                          | For Arch install                         |
| bison                  | Parser generator                       | For Yay dependency (base-devel)          |
| clang                  | C family compiler                      | For YouCompleteMe language server        |
| cmake                  | Make system                            | For YouCompleteMe dependency             |
| dmenu                  | Menu bar                               | For searching programs                   |
| dunst                  | Notification daemon                    | For displaying notifications             |
| feh                    | Image viewer                           | For setting wallpaper                    |
| firefox                | Browser                                | For browsing internet                    |
| flex                   | Generates text scanning programs       | For Yay dependency (base-devel)          |
| gdb                    | GNU debugger                           | For debugging                            |
| grub                   | Bootloader                             | For loading Linux kernel                 |
| i3-gaps                | Window manager                         | For managing windows                     |
| i3blocks               | Status bar                             | For displaying status                    |
| i3lock                 | Lock screen                            | For locking screen                       |
| imagemagick            | Image editor                           | For editing lockscreen                   |
| linux                  | Linux kernel                           | For running Linux                        |
| linux-firmware         | Linux firmware                         | For running Linux                        |
| make                   | GNU make utility                       | For Yay dependency (base-devel)          |
| man-db                 | Man pages                              | For reading program manuals              |
| neovim                 | Text editor                            | For editing text                         |
| net-tools              | Networking tools                       | For PIA VPN dependency                   |
| network-manager-applet | System tray for NetworkManager         | For Network Manager applet               |
| noto-fonts-emoji       | Font for emoji symbols                 | For rendering unicode symbols            |
| openssh                | SSH                                    | For SSH                                  |
| pacman-contrib         | Scripts and tools for Pacman systems   | For checkupdates                         |
| patch                  | Patches files                          | For Yay dependency (base-devel)          |
| picom                  | Compositor                             | For transparency                         |
| pkgconf                | Package compiler and linker            | For Yay dependency (base-devel)          |
| python-pynvim          | Python client for Neovim               | For Neovim Python plugins                |
| reflector              | Retrieve and filter Pacman mirror list | For updating Pacman mirror list          |
| ripgrep                | Grep tool                              | For searching files                      |
| scrot                  | Screen capture                         | For taking screenshots                   |
| simple-mtpfs *         | Media transfer protocol file system    | For mounting mobile phones               |
| ttf-symbola *          | Font for unicode symbols               | For rendering unicode on Dmenu           |
| valgrind               | Memory management tool                 | For catching memory leaks                |
| which                  | Show full path of commands             | For Yay dependency (base-devel)          |
| xclip                  | Manipulates X11 clipboard              | For copying unicode, Neovim copy on exit |
| xf86-video-intel       | XOrg video driver                      | For graphics display                     |
| xorg-server            | XOrg package                           | For running X                            |
| xorg-xbacklight        | Screen brightness                      | For brightness controls                  |
| xorg-xinit             | XOrg initialisation                    | For startx                               |
| xorg-xset              | Set lock timeout                       | For setting dim and lock screen timeouts |
| xss-lock               | Use external locker                    | For locking screen                       |
| yay *                  | AUR package manager                    | For installing AUR packages              |

\* = AUR packages
