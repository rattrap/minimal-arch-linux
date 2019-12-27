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
sudo pacman -S --noconfirm ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack noto-fonts
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Iosevka%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Roboto%20Mono%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Bold%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Light%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Medium%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Retina%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Regular.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Bold%20Italic.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Italic.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Bold.ttf

echo "Blacklisting bluetooth"
sudo touch /etc/modprobe.d/nobt.conf
sudo tee -a /etc/modprobe.d/nobt.conf << END
blacklist btusb
blacklist bluetooth
END
sudo mkinitcpio -p linux-lts
sudo mkinitcpio -p linux

echo "Downloading wallpapers"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/andre-benz-cXU6tNxhub0-unsplash.jpg
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/metalbuilding.jpeg
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/Phoenix-dark-grey.png

echo "Installing Node.js LTS"
sudo pacman -S --noconfirm nodejs-lts-erbium npm yarn

echo "Changing default npm directory"
mkdir "$HOME"/.npm-global
npm config set prefix "$HOME/.npm-global"
touch "$HOME"/.profile
tee -a "$HOME"/.profile << END
export PATH=$HOME/.npm-global/bin:$PATH
END
source "$HOME"/.profile

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

echo "Installing VS Code"
sudo pacman -S --noconfirm code

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

echo "Installing and setting zsh, oh-my-zsh and powerlevel10k"
sudo pacman -S --noconfirm zsh