#!/bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_base.sh
chmod +x 2_base.sh
sh ./2_base.sh

echo "Installing Xorg"
sudo pacman -S --noconfirm xorg

echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

echo "Installing awesome and dependencies"
yay -S --noconfirm awesome-git rofi-git pamac-aur otf-san-francisco flashfocus sddm-sugar-dark
sudo pacman -S --noconfirm feh picom imagemagick acpi xorg-xbacklight alsa-utils scrot nm-connection-editor blueman bluez bluez-utils xfce4-power-manager kitty rofi i3lock nautilus code unclutter redshift lxappearance

echo "Installing display manager"
sudo pacman -S --noconfirm sddm
sudo systemctl enable sddm.service

echo "Ricing system"
sudo wget -P ~/.config/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/awesome-dotfiles.tar.gz
sudo tar -zxvf ~/.config/awesome-dotfiles.tar.gz -C ~/.config/
sudo rm ~/.config/awesome-dotfiles.tar.gz

echo "Configuring neovim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +'PlugInstall --sync' +qa

echo "Your setup is ready. You can reboot now!"