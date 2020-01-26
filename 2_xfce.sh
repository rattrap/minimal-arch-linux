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
sudo pacman -S --noconfirm xfce4 xfce4-goodies qterminal tumbler network-manager-applet

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

echo "Installing color schemes"
sudo wget -P /usr/share/qtermwidget5/color-schemes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/qterminal/Kali-Dark.colorscheme
sudo wget -P /usr/share/qtermwidget5/color-schemes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/qterminal/Kali-Light.colorscheme

sudo wget -P /usr/share/xfce4/terminal/colorschemes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/kali/xfce-terminal/Kali.theme
sudo chown -R $USER /usr/share/xfce4/terminal/colorschemes/Kali.theme

echo "Installing configs"
sudo wget -P ~/.config/qterminal.org/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/qterminal/qterminal.ini
chown -R $USER ~/.config/qterminal.org

sudo wget -P ~/.config/xfce4/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/xfce/xfce-configs.tar.gz
sudo tar -zxvf ~/.config/xfce4/xfce-configs.tar.gz -C ~/.config/xfce4/
sudo rm ~/.config/xfce4/xfce-configs.tar.gz
chown -R $USER ~/.config/xfce4

sudo wget -P ~/.config/Thunar/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/xfce/thunar/uca.xml
sudo chown -R $USER ~/.config/Thunar

sudo wget -P /etc/xdg/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/xfce/xdg.tar.gz
sudo tar -zxvf /etc/xdg/xdg.tar.gz -C /etc/xdg/
sudo rm /etc/xdg/xdg.tar.gz

echo "Disabling saved sessions"
xfconf-query -c xfce4-session -p /general/SaveOnExit -s false

echo "Enabling notifications daemon"
sudo pacman -S xfce4-notifyd
sudo mkdir -p /etc/systemd/user/xfce4-notifyd.service.d/
sudo tee -a /etc/systemd/user/xfce4-notifyd.service.d/display_env.conf << END
[Service]
Environment="DISPLAY=:0.0"
END
systemctl --user start xfce4-notifyd

echo "Adding OpenVPN support"
sudo pacmam -S --noconfirm networkmanager-openvpn

echo "Installing i3-gaps and termite"
sudo pacman -S --noconfirm i3-gaps termite

echo "Ricing Termite"
mkdir -p ~/.config/termite
wget -P ~/.config/termite https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/termite/config.kali-dark
mv ~/.config/termite/config.kali-dark ~/.config/termite/config
mkdir -p ~/.config/gtk-3.0
touch ~/.config/gtk-3.0/gtk.css
tee -a ~/.config/gtk-3.0/gtk.css << END
VteTerminal, vte-terminal {
 padding: 18px;
}
END

echo "Your setup is ready. You can reboot now!"