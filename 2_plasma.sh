#!/bin/bash

user_name=""

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Xorg"
echo -en " \nyes" | sudo pacman -S xorg

echo "Installing Plasma and common applications"
echo -en " \n \nyes" | sudo pacman -S plasma ark dolphin dolphin-plugins gwenview kaccounts-integration kaccounts-providers kate kgpg kmail konsole kwalletmanager okular spectacle

echo "Installing Plasma wayland session"
yes | sudo pacman -S plasma-wayland-session