#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Xorg"
sudo pacman -S --noconfirm xorg

echo "Installing Plasma and common applications"
sudo pacman -S --noconfirm xfce4 xfce4-goodies

echo "Installing display manager"
sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

# missing !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo "Setting up autologin"
sudo tee -a /etc/lightdm/lightdm.conf << END

END 

echo "Installing gtk themes"
sudo wget -P /usr/share/themes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/kali/kali-dark.tar.gz
sudo wget -P /usr/share/themes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/kali/kali-light.tar.gz
sudo tar -zxvf /usr/share/themes/kali-dark.tar.gz
sudo rm /usr/share/icons/kali-dark.tar.gz
sudo tar -zxvf /usr/share/themes/kali-light.tar.gz
sudo rm /usr/share/icons/kali-light.tar.gz

echo "Installing gtk icons"
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/kali/Flat-Remix-Blue-Dark.tar.gz
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/kali/Flat-Remix-Blue-Light.tar.gz
sudo tar -zxvf /usr/share/icons/Flat-Remix-Blue-Dark.tar.gz
sudo rm /usr/share/icons/Flat-Remix-Blue-Dark.tar.gz
sudo tar -zxvf /usr/share/icons/Flat-Remix-Blue-Light.tar.gz
sudo rm /usr/share/icons/Flat-Remix-Blue-Light.tar.gz

echo "Your setup is ready. You can reboot now!"