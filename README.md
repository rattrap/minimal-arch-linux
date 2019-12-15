# Minimal Arch Linux setup - Install scripts

|                                                 Clean                                                 |                                               Busy                                                |
| :---------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------: |
| ![screenshot_2](https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/screenshot_2.png) | ![screenshot](https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/screenshot.png) |

## Install script

- LVM on LUKS
- LUKS2
- systemd-boot (with Pacman hook for automatic updates)
- systemd init hooks (instead of busybox)
- SSD Periodic TRIM
- Intel microcode
- Standard Kernel + LTS kernel as fallback
- AppArmor (with caching for faster startup)

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
| &nbsp;&nbsp;&nbsp;└─cryptlvm                        | crypt |            |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├─Arch-swap |  lvm  |   [SWAP]   |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─Arch-root |  lvm  |     /      |

## Post install script

- Sway (2_sway.sh), Gnome (2_gnome.sh) and KDE Plasma (2_plasma.sh) support
- UFW (deny incoming, allow outgoing)
- TLP
- Firejail with AppArmor integration
- zsh:
  - oh-my-zsh
  - powerlevel10k theme
- yay (AUR helper)
- Meslo Nerd Font
- swaywm:
  - (sway) Ayu Mirage color scheme (termite, neovim, rofi, waybar, VS Code)
    - Visual: [[Sway] Ayu (Updated)](https://www.reddit.com/r/unixporn/comments/dosu0c/sway_ayu_updated/)
  - GTK theme and icons: Custom Arc - Ayu Mirage + Papirus icons
  - autostart on tty1
  - waybar: onclick pavucontrol (volume control) and nmtui (ncli network manager)
  - swayidle and swaylock: automatic sleep and lock
  - Termite terminal
  - rofi as application launcher
  - slurp and grim for screenshots
  - Hibernate (power key) + suspend (lid close)
  - Automatic login (with systemd)
  - thunar (with USB automonting)
- Other applications: firefox, keepassxc, git, openssh, vim, Node.js LTS, tumbler, evince, thunderbird, upower, htop, VS code oss, nnn, neovim and a few others

## Installation guide

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
cryptsetup luksOpen /dev/nvme0n1p2 cryptlvm
mount /dev/vg0/Arch-root /mnt
arch-chroot /mnt
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

### Recommended Gnome extensions

- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [Dynamic Panel Transparency](https://extensions.gnome.org/extension/1011/dynamic-panel-transparency/)

### TODO (maybe)
- [Support secure boot](https://wiki.archlinux.org/index.php/Secure_Boot)
- Plymouth
- sway:
  - [Improve](https://www.reddit.com/r/swaywm/comments/bkzeo7/font_rendering_really_bad_and_rough_in_gtk3/?ref=readnext) [font](https://www.reddit.com/r/archlinux/comments/5r5ep8/make_your_arch_fonts_beautiful_easily/) [rendering](https://aur-dev.archlinux.org/packages/fontconfig-enhanced-defaults/) [with](https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671) [this](https://wiki.archlinux.org/index.php/Font_configuration#Incorrect_hinting_in_GTK_applications) [or this](https://www.reddit.com/r/archlinux/comments/9ujhbc/how_to_get_windows_like_font_rendering/)
  - Waybar: add battery discharge rate. Use [this config](https://gitlab.com/krathalan/waybar-modules/raw/3a652315f537ac957c37f08e55b5184da2b36cbd/mywaybar.jpg) as reference: [snippets](https://gitlab.com/snippets/1880686) and [modules](https://gitlab.com/krathalan/waybar-modules)
  - Use [swaylock-blur](https://github.com/cjbassi/swaylock-blur)
  - Add gestures to switch workspaces: [example](https://www.reddit.com/r/unixporn/comments/bd0l15/sway_real_world_student_workflow/ekv1ird?utm_source=share&utm_medium=web2x)