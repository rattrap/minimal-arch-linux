#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Enabling autologin"
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo touch /etc/systemd/system/getty@tty1.service.d/override.conf
sudo tee -a /etc/systemd/system/getty@tty1.service.d/override.conf << END
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --autologin $USER --noclear %I $TERM
END

echo "Removing last login message"
touch ~/.hushlogin

echo "Installing xwayland"
sudo pacman -S --noconfirm xorg-server-xwayland

echo "Installing Termite terminal"
sudo pacman -S --noconfirm termite

echo "Ricing Termite"
mkdir -p ~/.config/termite
wget -P ~/.config/termite https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/termite/config.monochrome-alt
mv ~/.config/termite/config.monochrome-alt ~/.config/termite/config

echo "Installing sway and additional packages"
sudo pacman -S --noconfirm sway swaylock swayidle waybar otf-font-awesome wl-clipboard pulseaudio pavucontrol rofi slurp grim thunar mousepad nnn light feh qalculate-gtk
mkdir -p ~/Pictures/screenshots
mkdir -p ~/.config/sway
wget -P ~/.config/sway/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/sway/config

echo "Making sway start on login"
wget -P ~/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/.zprofile.sway
mv .zprofile.sway .zprofile

echo "Installing office applications"
sudo pacman -S --noconfirm tumbler evince thunderbird

echo "Enabling auto-mount and archives creation/deflation for thunar"
sudo pacman -S --noconfirm gvfs thunar-volman thunar-archive-plugin ark file-roller xarchiver

echo "Ricing waybar"
mkdir -p ~/.config/waybar
wget -P ~/.config/waybar https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/waybar/config
wget -P ~/.config/waybar https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/waybar/style.css

echo "Ricing rofi"
mkdir -p ~/.config/rofi
wget -P ~/.config/rofi https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/rofi/config.rasi
wget -P ~/.config/rofi https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/rofi/monochromatic.rasi
mv ~/.config/rofi/monochromatic.rasi ~/.config/rofi/config.rasi

echo "Installing GTK theme and dependencies"
sudo pacman -S --noconfirm gtk-engine-murrine gtk-engines
sudo mkdir -p /usr/share/themes/
sudo wget -P /usr/share/themes/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/Qogir-win-light.tar.gz
sudo tar -xzf /usr/share/themes/Qogir-win-light.tar.gz -C /usr/share/themes/
sudo rm -f /usr/share/themes/Qogir-win-light.tar.gz

echo "Installing Tela icons"
sudo mkdir -p /usr/share/icons/
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/tela-icons.tar.gz
sudo tar -xzf /usr/share/icons/tela-icons.tar.gz -C /usr/share/icons/
sudo rm -f /usr/share/icons/tela-icons.tar.gz

echo "Setting GTK theme, font and icons"
FONT="MesloLGS NF Regular 10"
GTK_THEME="Qogir-win-light"
GTK_ICON_THEME="Tela-black"
GTK_SCHEMA="org.gnome.desktop.interface"
gsettings set $GTK_SCHEMA gtk-theme "$GTK_THEME"
gsettings set $GTK_SCHEMA icon-theme "$GTK_ICON_THEME"
gsettings set $GTK_SCHEMA font-name "$FONT"
gsettings set $GTK_SCHEMA document-font-name "$FONT"

echo "Enabling suspend and hibernate hotkeys"
sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=hibernate/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/g' /etc/systemd/logind.conf

echo "Adding VSCode theme"
code --install-extension viktorqvarfordt.vscode-pitch-black-theme

echo "Your setup is ready. You can reboot now!"