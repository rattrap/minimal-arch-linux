#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Xorg"
sudo pacman -S --noconfirm xorg

echo "Installing xfce and common applications"
sudo pacman -S --noconfirm xfce4 xfce4-goodies qterminal tumbler

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
sudo tar -zxvf /usr/share/themes/kali-dark.tar.gz
sudo rm /usr/share/icons/kali-dark.tar.gz
sudo tar -zxvf /usr/share/themes/kali-light.tar.gz
sudo rm /usr/share/icons/kali-light.tar.gz

echo "Installing gtk icons"
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/Flat-Remix-Blue-Dark.tar.gz
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/Flat-Remix-Blue-Light.tar.gz
sudo tar -zxvf /usr/share/icons/Flat-Remix-Blue-Dark.tar.gz
sudo rm /usr/share/icons/Flat-Remix-Blue-Dark.tar.gz
sudo tar -zxvf /usr/share/icons/Flat-Remix-Blue-Light.tar.gz
sudo rm /usr/share/icons/Flat-Remix-Blue-Light.tar.gz

echo "Installing color schemes"
sudo wget -P /usr/share/qtermwidget5/color-schemes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/qterminal/Kali-Dark.colorscheme
sudo wget -P /usr/share/qtermwidget5/color-schemes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/qterminal/Kali-Light.colorscheme

echo "Installing configs"
sudo wget -P ~/.config/qterminal.org/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/qterminal/qterminal.ini
sudo chown -R $USER ~/.config/qterminal.org

sudo wget -P ~/.config/xfce4/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/xfce/xfce-configs.tar.gz
sudo tar -zxvf ~/.config/xfce4/xfce-configs.tar.gz
sudo rm ~/.config/xfce4/xfce-configs.tar.gz
sudo chown -R $USER ~/.config/xfce4

sudo wget -P ~/.config/Thunar/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/xfce/thunar/uca.xml
sudo chown -R $USER ~/.config/Thunar

sudo wget -P /etc/xdg/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/xfce/xdg.tar.gz
sudo tar -zxvf /etc/xdg/xdg.tar.gz
sudo rm /etc/xdg/xdg.tar.gz

echo "Your setup is ready. You can reboot now!"