#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Xorg"
sudo pacman -S --noconfirm xorg

echo "Installing pulseaudio"
sudo pacman -S --noconfirm pulseaudio pavucontrol

echo "Installing xfce and common applications"
sudo pacman -S --noconfirm xfce4 xfce4-goodies tumbler network-manager-applet

echo "Enabling auto-mount and archives creation/deflation for thunar"
sudo pacman -S --noconfirm gvfs thunar-volman thunar-archive-plugin ark file-roller xarchiver

echo "Uniforming QT theme"
sudo pacman -S --noconfirm qt5-styleplugins
touch ~/.xinitrc
tee -a ~/.xinitrc << END
QT_QPA_PLATFORMTHEME=gtk2
END

echo "Installing display manager"
sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service

echo "Adding user to autologin group"
sudo groupadd -r autologin
sudo gpasswd -a $USER autologin

echo "Setting up autologin"
sudo tee -a /etc/lightdm/lightdm.conf << END
[Seat:*]
autologin-user=$USER
autologin-session=xfce
END

echo "Installing gtk themes"
sudo wget -P /usr/share/themes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/kali-dark.tar.gz
sudo wget -P /usr/share/themes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/kali-light.tar.gz
sudo tar -zxvf /usr/share/themes/kali-dark.tar.gz -C /usr/share/themes/
sudo rm /usr/share/icons/kali-dark.tar.gz
sudo tar -zxvf /usr/share/themes/kali-light.tar.gz -C /usr/share/themes/
sudo rm /usr/share/icons/kali-light.tar.gz

echo "Installing gtk icons"
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/Flat-Remix-Blue-Dark.tar.gz
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/Flat-Remix-Blue-Light.tar.gz
sudo tar -zxvf /usr/share/icons/Flat-Remix-Blue-Dark.tar.gz -C /usr/share/icons/
sudo rm /usr/share/icons/Flat-Remix-Blue-Dark.tar.gz
sudo tar -zxvf /usr/share/icons/Flat-Remix-Blue-Light.tar.gz -C /usr/share/icons/
sudo rm /usr/share/icons/Flat-Remix-Blue-Light.tar.gz

echo "Installing xfce configs"
sudo wget -P /etc/xdg/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/xfce/xdg.tar.gz
sudo tar -zxvf /etc/xdg/xdg.tar.gz -C /etc/xdg/
sudo rm /etc/xdg/xdg.tar.gz

echo "Enabling notifications daemon"
sudo pacman -S --noconfirm xfce4-notifyd
sudo mkdir -p /etc/systemd/user/xfce4-notifyd.service.d/
sudo tee -a /etc/systemd/user/xfce4-notifyd.service.d/display_env.conf << END
[Service]
Environment="DISPLAY=:0.0"
END
systemctl --user start xfce4-notifyd

echo "Adding OpenVPN support"
sudo pacmam -S --noconfirm networkmanager-openvpn

echo "Your setup is ready. You can reboot now!"