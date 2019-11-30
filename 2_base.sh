#!/bin/bash

echo "Installing common packages"
yes | sudo pacman -S dkms xorg-server-xwayland

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
yes | sudo pacman -S ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack ttf-fira-code noto-fonts gsfonts powerline-fonts

echo "Installing and setting zsh, oh-my-zsh and powerlevel10k"
yes | sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM"/themes/powerlevel10k
sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' "$HOME"/.zshrc

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
tee "$HOME"/.zshrc << END
export PATH=$HOME/.npm-global/bin:$PATH"
END

echo "Configuring neovim"
mkdir -p "$HOME"/.config/nvim
wget -P "$HOME"/.config/nvim https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/nvim/init.vim

echo "Installing vim-plug"
curl -fLo "$HOME"/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +'PlugInstall --sync' +qa

echo "Installing VS Code"
yes | sudo pacman -S code

echo "Installing VS Code theme + icons"
code --install-extension jolaleye.horizon-theme-vscode
code --install-extension pkief.material-icon-theme
code --install-extension esbenp.prettier-vscode

echo "Installing theme dependencies"
yes | sudo pacman -S gtk-engine-murrine gtk-engines

echo "Setting up Qogir (GTK) theme"
git clone https://github.com/vinceliuice/Qogir-theme.git
cd Qogir-theme || exit
sudo mkdir -p /usr/share/themes
sudo ./install.sh -d /usr/share/themes
cd ..
rm -rf Qogir-theme

echo "Setting up Qogir icons"
git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd Qogir-icon-theme || exit
sudo mkdir -p /usr/share/icons
sudo ./install.sh -d /usr/share/icons
cd ..
rm -rf Qogir-icon-theme

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

echo "Enabling audio power saving"
sudo touch /etc/modprobe.d/audio_powersave.conf
echo "options snd_hda_intel power_save=1" | sudo tee /etc/modprobe.d/audio_powersave.conf

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
