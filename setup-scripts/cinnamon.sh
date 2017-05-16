#!/bin/bash
# Installs and configures the desktop environment

echo
echo "Installing Cinnamon"
sudo pacman -S cinnamon


echo
echo "Installing themes"
sudo pacman -S faenza-icon-theme faience-icon-theme otf-fira-mono otf-fira-sans
aurget -S gtk-theme-arc ttf-roboto ttf-roboto-mono otf-fira-code otf-hasklig qt5-styleplugins --noedit


echo
echo "Installing utilities"
sudo pacman -S file-roller gnome-terminal gedit firefox system-config-printer konsole


echo
echo "After starting cinnamon, run 'desktop-environment/load-cinnamon-conf.sh'"
