#!/bin/bash

echo "Downloading and running base script"
https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
sh ./2_base.sh

echo "Creating user's folders"
yes | sudo pacman -S xdg-user-dirs

echo "Installing Alacritty terminal"
yes | sudo pacman -S alacritty

echo "Installing office applications"
yes | sudo pacman -S tumbler evince thunderbird

echo "Importing sway specific zsh configurations"
wget -P ~/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/sway/.zprofile
mkdir -p ~/.zshrc.d
wget -P ~/.zshrc.d https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/sway/.zshrc.d/environ.zsh
wget -P ~/.zshrc.d https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/sway/.zshrc.d/wayland.zsh

echo "Installing Material Design icons"
sudo mkdir -p /usr/share/fonts/TTF/
sudo wget -P /usr/share/fonts/TTF/ https://raw.githubusercontent.com/Templarian/MaterialDesign-Webfont/master/fonts/materialdesignicons-webfont.ttf

echo "Installing sway and additional packages"
yes | sudo pacman -S sway swaylock swayidle waybar wl-clipboard pulseaudio pavucontrol rofi slurp grim thunar mousepad nnn light feh qalculate-gtk
mkdir -p ~/.config/sway
wget -P ~/.config/sway/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/sway/config
mkdir -p ~/Pictures/screenshots

echo "Enabling auto-mount for thunar"
yes | sudo pacman -S gvfs thunar-volman

echo "Setting wallpaper"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpaper/omar-g-garnica-6gdqWFolkC4-unsplash.jpg

echo "Ricing waybar"
mkdir -p ~/.config/waybar
wget -P ~/.config/waybar https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/waybar/config
wget -P ~/.config/waybar https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/waybar/style.css

echo "Ricing Alacritty"
mkdir -p ~/.config/alacritty
wget -P ~/.config/alacritty https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/alacritty/alacritty.yml

echo "Ricing rofi"
mkdir -p ~/.config/rofi
wget -P ~/.config/rofi https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/rofi/config

echo "Your setup is ready. You can reboot now!"