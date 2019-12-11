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
