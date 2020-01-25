#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Blacklisting bluetooth"
sudo touch /etc/modprobe.d/nobt.conf
sudo tee -a /etc/modprobe.d/nobt.conf << END
blacklist btusb
blacklist bluetooth
END
sudo mkinitcpio -p linux-lts
sudo mkinitcpio -p linux

echo "Downloading wallpapers"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/762f2480-2590-49c5-8a37-3ad6b911184f.png
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/metalbuilding.jpeg
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/Phoenix-dark-grey.png

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
wget -P ~/.config/termite https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/termite/config.shapeshifter
mv ~/.config/termite/config.shapeshifter ~/.config/termite/config
mkdir -p ~/.config/gtk-3.0
touch ~/.config/gtk-3.0/gtk.css
tee -a ~/.config/gtk-3.0/gtk.css << END
VteTerminal, vte-terminal {
 padding: 18px;
}
END

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

echo "Installing Quintom Snow cursor"
sudo wget -P /usr/share/icons/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/themes/Quintom_Snow.tar.gz
sudo tar -xzf /usr/share/icons/Quintom_Snow.tar.gz -C /usr/share/icons/
sudo rm -f /usr/share/icons/Quintom_Snow.tar.gz

echo "Installing San Francisco Fonts"
git clone https://aur.archlinux.org/otf-san-francisco-pro.git
cd otf-san-francisco-pro
makepkg -si --noconfirm
cd ..
rm -rf otf-san-francisco-pro

echo "Setting GTK theme, font and icons"
FONT="San Francisco Pro Regular 10"
GTK_THEME="Qogir-win-light"
GTK_ICON_THEME="Tela-black"
GTK_SCHEMA="org.gnome.desktop.interface"
CURSOR_THEME="Quintom_Snow"
gsettings set $GTK_SCHEMA gtk-theme "$GTK_THEME"
gsettings set $GTK_SCHEMA icon-theme "$GTK_ICON_THEME"
gsettings set $GTK_SCHEMA font-name "$FONT"
gsettings set $GTK_SCHEMA document-font-name "$FONT"
gsettings set $GTK_SCHEMA cursor-theme "$CURSOR_THEME"

echo "Enabling suspend and hibernate hotkeys"
sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=hibernate/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/g' /etc/systemd/logind.conf

echo "Adding VSCode theme"
code --install-extension viktorqvarfordt.vscode-pitch-black-theme

echo "Applying VSCode user settings"
mkdir -p ~/.config/Code\ -\ OSS/User
wget -P ~/.config/Code\ -\ OSS/User https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/vscode/settings.json


echo "Your setup is ready. You can reboot now!"
