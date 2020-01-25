# Minimal Arch Linux setup - Install scripts

|                                                 Clean                                                 |                                               Busy                                                |
| :---------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------: |
| ![clean](https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/clean.png) | ![busy](https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/busy.png) |

## Install script

- LVM on LUKS
- LUKS2
- systemd-boot (with Pacman hook for automatic updates)
- systemd init hooks (instead of busybox)
- SSD Periodic TRIM
- Intel microcode
- Standard Kernel + LTS kernel as fallback

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

- Sway (2_sway.sh), i3 (2_i3.sh), Gnome (2_gnome.sh) and KDE Plasma (2_plasma.sh) support
- Plymouth
- UFW (deny incoming, allow outgoing)
- Meslo NG Nerd Font
- ZSH with Oh-My-Zsh and Powerlevel10k
- Automatic login (with systemd)
- yay (AUR helper)
- swaywm:
  - GTK theme and icons: Qogir win light + Papirus Dark icons
  - autostart on tty1
  - waybar: onclick pavucontrol (volume control) and nmtui (ncli network manager)
  - swayidle and swaylock: automatic sleep and lock
  - Termite terminal
  - rofi as application launcher
  - slurp and grim for screenshots
  - Hibernate (power key) + suspend (lid close)
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

### How to install Go lang
```
echo "Installing Go lang"
sudo pacman -S --noconfirm go dep go-tools
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
- [Multi-touch Zoom](https://addons.mozilla.org/en-US/firefox/addon/multi-touch-zoom/)
- [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/)
- [Firefox - Ayu Mirage theme](https://addons.mozilla.org/en-US/firefox/addon/ayu-mirage/)

### Recommended Gnome extensions

- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [Dynamic Panel Transparency](https://extensions.gnome.org/extension/1011/dynamic-panel-transparency/)

### How to install yay
```
echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin
```

### How to install zsh with powerlevel10k and oh-my-zsh
```
echo "Installing and setting zsh, oh-my-zsh and powerlevel10k"
sudo pacman -S --noconfirm zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k
rm -rf "$HOME"/.zshrc
wget -P "$HOME" https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/.zshrc
rm -rf "$HOME"/.p10k.zsh
wget -P "$HOME" https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/.p10k.zsh
```

### Secure Boot with Linux Foundation Preloader
```
yay -S preloader-signed
sudo cp /usr/share/preloader-signed/{PreLoader,HashTool}.efi /boot/EFI/systemd
sudo cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi
sudo efibootmgr --verbose --disk /dev/nvme0n1 --part 1 --create --label "PreLoader" --loader /EFI/systemd/PreLoader.efi
```

### Plymouth
```
echo "Installing and configuring Plymouth"
yay -S --noconfirm plymouth
sudo sed -i 's/base systemd autodetect/base systemd sd-plymouth autodetect/g' /etc/mkinitcpio.conf
sudo sed -i 's/quiet rw/quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0 rw/g' /boot/loader/entries/arch.conf
# Arch LTS left out on purpose, in case there's an issue with Plymouth

echo "Installing and setting plymouth theme"
yay -S --noconfirm plymouth-theme-arch-breeze-git
sudo plymouth-set-default-theme -R arch-breeze
```

### TODO (maybe)
- [Support secure boot](https://wiki.archlinux.org/index.php/Secure_Boot)
- Waybar: add battery discharge rate. Use [this config](https://gitlab.com/krathalan/waybar-modules/raw/3a652315f537ac957c37f08e55b5184da2b36cbd/mywaybar.jpg) as reference: [snippets](https://gitlab.com/snippets/1880686) and [modules](https://gitlab.com/krathalan/waybar-modules)
- Use [swaylock-blur](https://github.com/cjbassi/swaylock-blur)
- Add gestures to switch workspaces: [example](https://www.reddit.com/r/unixporn/comments/bd0l15/sway_real_world_student_workflow/ekv1ird?utm_source=share&utm_medium=web2x)
