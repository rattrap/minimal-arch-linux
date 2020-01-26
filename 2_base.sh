#!/bin/bash

echo "Updating packages"
sudo pacman -Syu --noconfirm

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
sudo pacman -S --noconfirm firefox chromium keepassxc git openssh neovim links upower htop powertop p7zip ripgrep unzip code

echo "Creating user's folders"
sudo pacman -S --noconfirm xdg-user-dirs

echo "Installing fonts"
sudo pacman -S --noconfirm ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack noto-fonts ttf-fira-code cantarell-fonts

echo "Downloading wallpapers"
wget -P ~/Pictures/ https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/wallpapers/buzz-andersen-E4944K_4SvI-unsplash.jpg

echo "Installing Node.js LTS"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
nvm install --lts=erbium

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

echo "Installing and setting zsh, oh-my-zsh and powerlevel10k"
sudo pacman -S --noconfirm zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k