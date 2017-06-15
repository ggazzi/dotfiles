#!/bin/bash
# Installs and configures the desktop environment

echo
echo "Installing Gnome"
sudo pacman -S adwaita-icon-theme baobab eog evince gnome-backgrounds gnome-calculator gnome-control-center gnome-dictionary gnome-disk-utility gnome-font-viewer gnome-keyring gnome-screenshot gnome-session gnome-settings-daemon gnome-shell gnome-shell-extensions gnome-system-monitor gnome-themes-standard gnome-user-docs gnome-user-share grilo-plugins gtk3-print-backends gucharmap gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb mutter nautilus networkmanager sushi tracker xdg-user-dirs-gtk yelp gnome-tweak-tool

echo
echo "Installing themes"
sudo pacman -S faenza-icon-theme faience-icon-theme otf-fira-mono otf-fira-sans
sudo aura -A gtk-theme-arc-git ttf-roboto ttf-roboto-mono otf-fira-code otf-hasklig qt5-styleplugins


echo
echo "Installing utilities"
sudo pacman -S file-roller gnome-terminal gedit firefox system-config-printer konsole okular
sudo aura -A nautilus-dropbox 
