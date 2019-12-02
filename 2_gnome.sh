#!/bin/bash

user_name=""

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Gnome and a few extra apps"
echo -en " \nyes" | sudo pacman -S gnome gnome-tweaks gnome-usage gitg evolution gvfs-goa

echo "Enabling GDM"
sudo systemctl enable gdm.service

# echo "Changing Gnome power settings"
# gsettings set org.gnome.desktop.screensaver lock-enabled 'true'
# gsettings set org.gnome.desktop.screensaver lock-delay 600
# gsettings set org.gnome.settings-daemon.plugins.power sleep-display-ac 600
# gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
# gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type hibernate
# gsettings set org.gnome.settings-daemon.plugins.power sleep-display-battery 600
# gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1800
# gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type hibernate
# gsettings set org.gnome.settings-daemon.plugins.power power-button-action suspend

# echo "Changing battery level notifications and action"
# sudo mkdir -p /etc/UPower/
# sudo touch /etc/UPower/UPower.conf
# sudo tee -a /etc/UPower/UPower.conf << END
# PercentageLow=15
# PercentageCritical=5
# PercentageAction=2
# CriticalPowerAction=HybridSleep
# END

# echo "Setting misc usability settings"
# sudo -u gdm gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
# gsettings set org.gnome.gedit.preferences.editor display-line-numbers true

# echo "Changing Gnome fonts"
# gsettings set org.gnome.desktop.interface text-scaling-factor '1.0'
# gsettings set org.gnome.desktop.interface monospace-font-name "Hack 10"
# gsettings set org.gnome.desktop.interface document-font-name 'Roboto 10'
# gsettings set org.gnome.desktop.interface font-name 'Roboto 10'
# gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto Bold 10'
# gsettings set org.gnome.nautilus.desktop font 'Roboto 10'

# echo "Enabling automatic login"
# sudo mkdir -p /etc/gdm/
# sudo touch /etc/gdm/custom.conf
# sudo tee -a /etc/gdm/custom.conf << END
# # Enable automatic login for user
# [daemon]
# AutomaticLogin=$user_name
# AutomaticLoginEnable=True
# END