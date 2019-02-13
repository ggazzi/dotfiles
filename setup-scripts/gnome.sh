#!/bin/bash
# Installs and configures the desktop environment

echo
echo "Installing Gnome"
sudo pacman -S adwaita-icon-theme baobab eog evince gnome-backgrounds gnome-calculator gnome-control-center gnome-dictionary gnome-disk-utility gnome-font-viewer gnome-keyring gnome-screenshot gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-themes-standard gnome-user-docs gnome-user-share grilo-plugins gtk3-print-backends gucharmap gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb mutter nautilus networkmanager sushi tracker xdg-user-dirs-gtk yelp gnome-tweak-tool gnome-calendar dconf-editor gnome-contacts gnome-documents gnome-weather evolution vlc ffmpegthumbnailer xorg-xrandr

echo
echo "Installing themes"
sudo pacman -S otf-fira-mono otf-fira-sans arc-gtk-theme arc-icon-theme gtk-engine-murrine arc-kde qt5-styleplugins
aurget -S --noedit otf-fira-code-mozilla otf-hasklig

echo
echo "Installing utilities"
sudo pacman -S file-roller gnome-terminal gedit firefox system-config-printer
#aurget -S --noedit nautilus-dropbox

echo
echo "Installing vs code"
sudo pacman -S gconf
aurget -S --noedit visual-studio-code

echo
echo "Installing gnome shell extensions"
aurget -S --noedit chrome-gnome-shell-git


echo
echo "Installing utilities to backup/restore config"
sudo pacman -S python-pip
pip install --user pyyaml
