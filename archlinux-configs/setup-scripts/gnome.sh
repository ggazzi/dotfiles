#!/bin/bash
# Installs and configures the desktop environment

echo
echo "Installing Gnome"
sudo pacman -S gnome dconf-editor gnome-tweaks

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

echo
echo "Installing automatic wallpaper switcher"
sudo pacman -S variety

echo
echo "Installing file sync"
aurget -S --noedit dropbox dropbox-cli nautilus-dropbox