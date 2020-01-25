#!/bin/bash

echo "Updating packages"
sudo pacman -Syu --noconfirm

echo "Installing and configuring UFW"
sudo pacman -S --noconfirm ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Improving Intel GPU support"
sudo pacman -S --noconfirm intel-media-driver

echo "Adding Vulkan support"
sudo pacman -S --noconfirm vulkan-intel vulkan-icd-loader

echo "Installing common applications"
sudo pacman -S --noconfirm firefox chromium keepassxc git openssh neovim links upower htop powertop p7zip ripgrep unzip

echo "Creating user's folders"
sudo pacman -S --noconfirm xdg-user-dirs

echo "Installing fonts"
sudo pacman -S --noconfirm ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack noto-fonts ttf-fira-code cantarell-fonts

echo "Downloading wallpapers"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/buzz-andersen-E4944K_4SvI-unsplash.jpg

echo "Installing Node.js LTS"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
nvm install --lts=erbium

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

echo "Installing and configuring Plymouth"
yay -S --noconfirm plymouth
sudo sed -i 's/base systemd autodetect/base systemd sd-plymouth autodetect/g' /etc/mkinitcpio.conf
sudo sed -i 's/quiet rw/quiet splash loglevel=3 rd.udev.log_priority=3 vt.global_cursor_default=0 rw/g' /boot/loader/entries/arch.conf
# Arch LTS left out on purpose, in case there's an issue with Plymouth

echo "Installing and setting plymouth theme"
yay -S --noconfirm plymouth-theme-arch-breeze-git
sudo plymouth-set-default-theme -R arch-breeze