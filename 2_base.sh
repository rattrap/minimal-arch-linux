#!/bin/bash

echo "Updating databases"
sudo pacman -Syu

echo "Enabling AppArmor cache"
sudo sed -i 's/#write-cache/write-cache/g' /etc/apparmor/parser.conf

echo "Installing DKMS packages"
yes | sudo pacman -S dkms

echo "Installing and configuring UFW"
yes | sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Improving Intel GPU support"
yes | sudo pacman -S vulkan-intel intel-media-driver

echo "Installing common applications"
echo -en "1\nyes" | sudo pacman -S firefox chromium keepassxc git openssh neovim links upower htop powertop p7zip ripgrep unzip

echo "Installing fonts"
yes | sudo pacman -S ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack ttf-fira-code noto-fonts ttf-font-awesome

echo "Installing San Francisco Fonts"
git clone https://aur.archlinux.org/otf-san-francisco-pro.git
cd otf-san-francisco-pro
yes | makepkg -si
cd ..
rm -rf otf-san-francisco-pro

echo "Installing and setting zsh, oh-my-zsh and powerlevel10k"
yes | sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k
rm -rf "$HOME"/.zshrc
wget -P "$HOME" https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/zsh/.zshrc

echo "Installing Node.js LTS"
yes | sudo pacman -S nodejs-lts-erbium npm

echo "Changing default npm directory"
mkdir "$HOME"/.npm-global
npm config set prefix "$HOME/.npm-global"
touch "$HOME"/.profile
tee "$HOME"/.profile << END
export PATH=$HOME/.npm-global/bin:$PATH
END
source "$HOME"/.profile

echo "Installing VS Code"
yes | sudo pacman -S code

echo "Installing VS Code theme + icons"
code --install-extension teabyii.ayu
code --install-extension pkief.material-icon-theme
code --install-extension esbenp.prettier-vscode

echo "Blacklisting bluetooth"
sudo touch /etc/modprobe.d/nobt.conf
sudo tee /etc/modprobe.d/nobt.conf << END
blacklist btusb
blacklist bluetooth
END
sudo mkinitcpio -p linux-lts
sudo mkinitcpio -p linux

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

echo "Installing and configuring Firejail"
yes | sudo pacman -S firejail
sudo apparmor_parser -r /etc/apparmor.d/firejail-default
sudo firecfg
sudo touch /etc/pacman.d/hooks/firejail.hook
sudo tee -a /etc/pacman.d/hooks/firejail.hook << END
[Trigger]
Type = File
Operation = Install
Operation = Upgrade
Operation = Remove
Target = usr/bin/*
Target = usr/local/bin/*
Target = usr/share/applications/*.desktop
[Action]
Description = Configure symlinks in /usr/local/bin based on firecfg.config...
When = PostTransaction
Depends = firejail
Exec = /bin/sh -c 'firecfg &>/dev/null'
END

echo "Granting internet access again to VSCode in Firejail profile"
sudo sed -i 's/net none/#net none/g' /etc/firejail/code.profile
sudo firecfg
