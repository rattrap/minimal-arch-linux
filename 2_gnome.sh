#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Gnome and a few extra apps"
sudo pacman -S --noconfirm gnome gnome-tweaks gnome-usage gitg evolution gvfs-goa

echo "Enabling GDM"
sudo systemctl enable gdm.service

echo "Enabling automatic login"
sudo tee -a /etc/lightdm/lightdm.conf << END
# Enable automatic login for user
[daemon]
AutomaticLogin=$USER
AutomaticLoginEnable=True
END

echo "Your setup is ready. You can reboot now!"