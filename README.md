# Minimal Arch Linux setup - Install scripts

|                                                 Clean                                                 |                                               Busy                                                |
| :---------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------: |
| ![screenshot_2](https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/screenshot_2.png) | ![screenshot](https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/screenshot.png) |

## Install script

- LVM on LUKS
- LUKS2
- systemd-boot (with Pacman hook for automatic updates)
- Automatic login (with systemd)
- SSD Periodic TRIM
- Intel microcode
- Automatic sort of mirrors list by speed, synced within the last 12 hours and filtered by HTTPS protocol (Reflector with Pacman hook)
- Standard Kernel + LTS kernel as fallback
- AppArmor
- Hibernate (power key) + suspend (lid close)

### Requirements

- UEFI mode
- NVMe SSD
- TRIM compatible SSD
- Intel CPU

### Partitions

| Name                                                  | Type  | Mountpoint |
| ----------------------------------------------------- | :---: | :--------: |
| nvme0n1                                               | disk  |            |
| ├─nvme0n1p1                                           | part  |   /boot    |
| ├─nvme0n1p2                                           | part  |            |
| &nbsp;&nbsp;&nbsp;└─cryptoVols                        | crypt |            |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├─Arch-swap |  lvm  |   [SWAP]   |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─Arch-root |  lvm  |     /      |

## Post install script

- Sway (2_sway.sh), Gnome (2_gnome.sh) and KDE Plasma (2_plasma.sh) support
  - Gnome and KDE have very basic support
- UFW (deny incoming, allow outgoing)
- Firejail (with AppArmor integration)
- TLP (default settings)
- Horizon Dark color scheme (alacritty, neovim, rofi, waybar, VS Code)
- swaywm:
  - autostart on tty1
  - waybar: onclick pavucontrol (volume control) and nmtui (ncli network manager)
  - swayidle and swaylock: automatic sleep and lock
  - Alacritty terminal
  - rofi as application launcher
  - slurp and grim for screenshots
- zsh:
  - powerlevel9k theme
  - oh-my-zsh
  - ~~Force wayland for QT applications~~ disabled due to incompatibility with keepassxc
  - ~~Force wayland for GTK applications~~ disabled due to incompatibility with electron apps (e.g. VS Code)
- neovim:
  - nerdtree
  - coc
  - denite
- GTK theme and icons: Qogir
- Other applications: firefox, keepassxc, git, openssh, vim, thunar (with USB automonting), golang, Node.js LTS, tumbler, evince, gimp, inkscape, thunderbird, upower, htop, VS code oss, nnn and a few others

## Quick start / Brief install guide

_See 'Detailed installation guide' below for the expanded version_

- Increase cowspace partition so that git can be downloaded without before chroot: `mount -o remount,size=2G /run/archiso/cowspace`
- Install git: `pacman -Sy git`
- Clone repository: `git clone https://github.com/exah-io/minimal-arch-linux.git`
- Run install script: `bash minimal-arch-linux/1_arch_install.sh`

## Detailed installation guide

1. Download and boot into the latest [Arch Linux iso](https://www.archlinux.org/download/)
2. Connect to the internet. If using wifi, you can use `wifi-menu` to connect to a network
3. Clear all existing partitions (see below: MISC - How to clear all partitions)
4. (optional) Give highest priority to the closest mirror to you on /etc/pacman.d/mirrorlist by moving it to the top
5. `wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/1_arch_install.sh`
6. Change the variables at the top of the file (lines 3 through 9)
   - continent_country must have the following format: Zone/SubZone . e.g. Europe/Berlin
   - run `timedatectl list-timezones` to see full list of zones and subzones
7. Make the script executable: `chmod +x 1_arch_install.sh`
8. Run the script: `./1_arch_install.sh`
9. Reboot into Arch Linux
10. Connect to wifi with `nmtui`
11. `wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_sway.sh`
12. Make the script executable: `chmod +x 2_sway.sh`
13. Run the script: `./2_sway.sh`

## Misc guides

### How to clear all partitions

```
gdisk /dev/nvme0n1
x
z
y
y
```

### VSCode - Settings

- Install ESLint on a per project basis: npm i eslint
- Check the following settings:
  - editor.formatOnSave
  - Prettier: Use Tabs
  - enablePreview
  - @tag:usesOnlineServices

### Recommended Firefox add-ons

- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
- [HTTPS Everywhere](https://addons.mozilla.org/en-US/firefox/addon/https-everywhere/)
- [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/)

### How to setup Github with SSH Key

```
git config --global user.email "Github external email"
git config --global user.name "Github username"
ssh-keygen -t rsa -b 4096 -C "Github email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
copy SSH key and add to Github (eg. nvim ~/.ssh/id_rsa.pub and copy content)
```

### How to chroot

```
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
cryptsetup luksOpen /dev/nvme0n1p2 cryptoVols
mount /dev/mapper/Arch-root /mnt
arch-chroot /mnt
```

### How to install yay

```
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
yes | makepkg -si
cd ..
rm -rf yay-bin
```

### Recommended Gnome extensions

- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [Dynamic Panel Transparency](https://extensions.gnome.org/extension/1011/dynamic-panel-transparency/)
