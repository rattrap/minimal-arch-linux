#!/bin/bash

echo "Installing common packages"
yes | sudo pacman -S linux-headers dkms xorg-server-xwayland

echo "Installing and configuring UFW"
yes | sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Installing and enabling TLP"
yes | sudo pacman -S tlp tlp-rdw
sudo systemctl enable tlp.service
sudo systemctl enable tlp.service
sudo systemctl start tlp.service
sudo systemctl start tlp.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

echo "Installing common applications"
echo -en "1\nyes" | sudo pacman -S firefox chromium keepassxc git openssh neovim links upower htop powertop p7zip ripgrep unzip

echo "Installing fonts"
yes | sudo pacman -S ttf-roboto ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack ttf-fira-code noto-fonts gsfonts powerline-fonts

echo "Installing and setting zsh, oh-my-zsh and powerlevel9k"
yes | sudo pacman -S zsh zsh-theme-powerlevel9k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel9k
sed -i 's/robbyrussell/powerlevel9k\/powerlevel9k/g' "$HOME"/.zshrc
{ echo 'POWERLEVEL9K_DISABLE_RPROMPT=true'; echo 'POWERLEVEL9K_PROMPT_ON_NEWLINE=true';  echo 'POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶ "'; echo 'POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)'; } >> "$HOME"/.zshrc

echo "Installing Node.js LTS"
yes | sudo pacman -S nodejs-lts-dubnium npm

echo "Changing default npm directory"
mkdir "$HOME"/.npm-global
npm config set prefix "$HOME/.npm-global"
touch "$HOME"/.profile
tee "$HOME"/.profile << END
export PATH=$HOME/.npm-global/bin:$PATH
END
source "$HOME"/.profile
echo "export PATH=$HOME/.npm-global/bin:$PATH" >> "$HOME"/.zshrc

#echo "Installing image editing applications"
#yes | sudo pacman -S gimp inkscape

# echo "Configuring golang with LSP server"
# yes | sudo pacman -S go go-tools
# mkdir -p $HOME/go/src
# GO111MODULE=on go get golang.org/x/tools/gopls@latest

#echo "Installing NVM and Node.js LTS"
#git clone https://aur.archlinux.org/nvm.git
#cd nvm
#yes | makepkg -si
#cd ..
#rm -rf nvm
#source /usr/share/nvm/init-nvm.sh
#nvm install --lts=dubnium

#echo "Adding Node.js provider for neovim"
#npm install -g neovim

#echo "Installing spacemacs"
#yes | sudo pacman -S emacs adobe-source-code-pro-fonts
#git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

echo "Adding Python 3 provider for neovim"
yes | sudo pacman -S python-pip
pip3 install --user --upgrade pynvim
#sudo pip3 install pylint # Linter
#pip install pep8 # Formatter

echo "Configuring neovim"
mkdir -p "$HOME"/.config/nvim
wget -P "$HOME"/.config/nvim https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/nvim/init.vim
wget -P "$HOME"/.config/nvim https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/configs/nvim/coc-settings.json

echo "Installing vim-plug"
curl -fLo "$HOME"/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +'PlugInstall --sync' +qa

echo "Installing neovim language extensions"
nvim +'CocInstall -sync coc-json' +qall
nvim +'CocInstall -sync coc-tsserver' +qall
nvim +'CocInstall -sync coc-html' +qall
nvim +'CocInstall -sync coc-css' +qall
#nvim +'CocInstall -sync coc-python' +qall
nvim +'CocInstall -sync coc-svg' +qall
nvim +'CocInstall -sync coc-eslint' +qall
nvim +'CocInstall -sync coc-prettier' +qall
#nvim +'silent :GoInstallBinaries' +qall

echo "Installing VS Code"
yes | sudo pacman -S code

echo "Installing VS Code theme + icons"
code --install-extension jolaleye.horizon-theme-vscode
code --install-extension pkief.material-icon-theme
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-azuretools.vscode-docker

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