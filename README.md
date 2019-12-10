# Minimal Arch Linux setup - Install scripts
- Revamp undergoing. There are still some things a bit rough on the edges, like the icons on waybar

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
- Standard Kernel + LTS kernel as fallback
- AppArmor (with Firefox + LibreOffice profiles)
- Hibernate (power key) + suspend (lid close)

### Requirements

- UEFI mode
- NVMe SSD
- TRIM compatible SSD
- Intel CPU (recommended: Skylake or newer due to fastboot)

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
- Ayu Mirage color scheme (alacritty, neovim, rofi, waybar, VS Code)
  - Visual: [[Sway] Ayu (Updated)](https://www.reddit.com/r/unixporn/comments/dosu0c/sway_ayu_updated/)
- swaywm:
  - autostart on tty1
  - waybar: onclick pavucontrol (volume control) and nmtui (ncli network manager)
  - swayidle and swaylock: automatic sleep and lock
  - Alacritty terminal
  - rofi as application launcher
  - slurp and grim for screenshots
- zsh:
  - powerlevel10k theme
  - oh-my-zsh
- neovim
- GTK theme and icons: Custom Arc - Ayu Mirage + Papirus icons
- Other applications: firefox, keepassxc, git, openssh, vim, thunar (with USB automonting), Node.js LTS, tumbler, evince, thunderbird, upower, htop, VS code oss, nnn and a few others

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
- [Firefox - Ayu Mirage theme](https://addons.mozilla.org/en-US/firefox/addon/ayu-mirage/)

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

### TODO
- [Improve](https://www.reddit.com/r/swaywm/comments/bkzeo7/font_rendering_really_bad_and_rough_in_gtk3/?ref=readnext) [font](https://www.reddit.com/r/archlinux/comments/5r5ep8/make_your_arch_fonts_beautiful_easily/) [rendering](https://aur-dev.archlinux.org/packages/fontconfig-enhanced-defaults/) [with](https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671) [this](https://wiki.archlinux.org/index.php/Font_configuration#Incorrect_hinting_in_GTK_applications) [or this](https://www.reddit.com/r/archlinux/comments/9ujhbc/how_to_get_windows_like_font_rendering/)
- [Support secure boot](https://wiki.archlinux.org/index.php/Secure_Boot)
- Waybar: add battery discharge rate. Use [this config](https://gitlab.com/krathalan/waybar-modules/raw/3a652315f537ac957c37f08e55b5184da2b36cbd/mywaybar.jpg) as reference: [snippets](https://gitlab.com/snippets/1880686) and [modules](https://gitlab.com/krathalan/waybar-modules)
- Use [swaylock-blur](https://github.com/cjbassi/swaylock-blur)
- Add gestures to switch workspaces: [example](https://www.reddit.com/r/unixporn/comments/bd0l15/sway_real_world_student_workflow/ekv1ird?utm_source=share&utm_medium=web2x)