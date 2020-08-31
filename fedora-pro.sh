#!/usr/bin/env bash
set -e

# Install git
read -p "Install git? (y)es/(n)o: " -n 1 -r
echo

if [[ $REPLY =~ [Yy]$ ]]
then
    
    read -p "git name: " git_name
    echo

    read -p "git: email: " git_email
    echo

    sudo dnf install git
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
fi

# rpm fusion
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install deps
sudo dnf install gnome-shell-extension-user-theme sassc glib2-devel gnome-shell-extension-dash-to-dock gnome-tweaks papirus-icon-theme gnome-shell-extension-appindicator -y

# Install theme files
theme_folder=Mojave-gtk-theme
if [[ -d "./$theme_folder" ]]
then
    cd ./$theme_folder
    git pull
    cd ..
else
    git clone https://github.com/vinceliuice/Mojave-gtk-theme.git $theme_folder
fi
cp ./activities.svg ./$theme_folder/src/assets/gnome-shell/assets-dark/activities/activities-fedora.svg
cp ./activities-light.svg ./$theme_folder/src/assets/gnome-shell/assets-light/activities/activities-fedora.svg
cp ./fuji-san-blur.png ./$theme_folder/src/assets/gnome-shell/assets-light/background.png
cp ./fuji-san-blur.png ./$theme_folder/src/assets/gnome-shell/assets-dark/background.png
./$theme_folder/install.sh -o standard -a standard -s standard -i fedora


# enable extensions
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

# theme settings
gsettings set org.gnome.shell.extensions.user-theme name "Mojave-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Mojave-dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

# extension settings
gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock animate-show-apps false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell.extensions.dash-to-dock show-delay 0.1
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

# background image
sudo mkdir -p /usr/share/backgrounds/fedora-pro
sudo cp ./fuji-san.jpg /usr/share/backgrounds/fedora-pro/fuji-san.jpg
sudo chown -R root:root /usr/share/backgrounds/fedora-pro
sudo chmod -R 744 /usr/share/backgrounds/fedora-pro
sudo chmod 755 /usr/share/backgrounds/fedora-pro
gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/fedora-pro/fuji-san.jpg
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#FFFFFF'

# applications
read -p "Install applications? (y)es/(n)o: " -n 1 -r
echo

if [[ $REPLY =~ [Yy]$ ]]
then
    sudo dnf install -y chromium wget
    sudo flatpak install -y flathub com.spotify.Client
    if [[ ! -d ~/.local/share/JetBrains/Toolbox/ ]]
    then
        wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.7391.tar.gz
        tar -xzf jetbrains-toolbox-1.17.7391.tar.gz
        ./jetbrains-toolbox-1.17.7391/jetbrains-toolbox
    fi
fi
