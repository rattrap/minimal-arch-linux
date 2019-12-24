#!/bin/bash

echo "Updating packages"
sudo pacman -Syu --noconfirm

echo "Installing DKMS packages"
sudo pacman -S --noconfirm dkms

echo "Installing and configuring UFW"
sudo pacman -S --noconfirm ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Improving Intel GPU support"
sudo pacman -S --noconfirm intel-media-driver

echo "Adding Vulkan support"
sudo pacman -S --noconfirm vulkan-intel vulkan-icd-loader

echo "Installing common applications"
sudo pacman -S --noconfirm firefox chromium keepassxc git openssh neovim links upower htop powertop p7zip ripgrep unzip

echo "Creating user's folders"
sudo pacman -S --noconfirm xdg-user-dirs

echo "Installing fonts"
sudo pacman -S --noconfirm ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack noto-fonts
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Iosevka%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Roboto%20Mono%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Bold%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Light%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Medium%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/Fira%20Code%20Retina%20Nerd%20Font%20Complete.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Regular.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Bold%20Italic.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Italic.ttf
sudo wget -P /usr/share/fonts/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/fonts/MesloLGS%20NF%20Bold.ttf

echo "Blacklisting bluetooth"
sudo touch /etc/modprobe.d/nobt.conf
sudo tee -a /etc/modprobe.d/nobt.conf << END
blacklist btusb
blacklist bluetooth
END
sudo mkinitcpio -p linux-lts
sudo mkinitcpio -p linux

echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

echo "Downloading wallpapers"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/andre-benz-cXU6tNxhub0-unsplash.jpg
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/metalbuilding.jpeg

echo "Installing and configuring fish"
sudo pacman -S --noconfirm fish
tee -a ~/.bashrc << END
exec fish
END

echo "Installing and configuring Starship prompt"
yay -S --noconfirm starship-bin
touch ~/.config/fish/config.fish
tee -a ~/.config/fish/config.fish << END
# Hide the fish greeting
set fish_greeting ""

# Syntax highlighting
set -g fish_color_command --bold

# Load Starship prompt
starship init fish | source
END

echo "Installing Node.js LTS"
sudo pacman -S --noconfirm nodejs-lts-erbium npm yarn

echo "Changing default npm directory"
mkdir "$HOME"/.npm-global
npm config set prefix "$HOME/.npm-global"
touch "$HOME"/.profile
tee -a "$HOME"/.profile << END
export PATH=$HOME/.npm-global/bin:$PATH
END
source "$HOME"/.profile

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

echo "Installing Go lang"
sudo pacman -S --noconfirm go dep go-tools

echo "Installing VS Code"
sudo pacman -S --noconfirm code