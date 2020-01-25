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
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/762f2480-2590-49c5-8a37-3ad6b911184f.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/metalbuilding.jpeg
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/Phoenix-dark-grey.png

echo "Installing Node.js LTS"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
nvm install --lts=erbium

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system
