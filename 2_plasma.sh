#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Xorg"
sudo pacman -S --noconfirm xorg

echo "Installing Plasma and common applications"
sudo pacman -S --noconfirm plasma ark dolphin dolphin-plugins gwenview kaccounts-integration kaccounts-providers kate kgpg kmail konsole kwalletmanager okular spectacle

echo "Installing Plasma wayland session"
sudo pacman -S --noconfirm plasma-wayland-session

echo "Installing SDDM and SDDM-KCM"
sudo pacman -S --noconfirm sddm sddm-kcm
sudo systemctl enable sddm.service

echo "Setting up autologin"
sudo mkdir -p /etc/sddm.conf.d/
sudo touch /etc/sddm.conf.d/autologin.conf
sudo tee /etc/sddm.conf.d/autologin.conf << END
[Autologin]
User=$USER
Session=plasma.desktop
END 