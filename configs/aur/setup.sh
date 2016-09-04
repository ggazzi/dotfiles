#!/bin/bash

# Install wget
sudo pacman -S wget

# Install aurget
echo ""
echo "Installing aurget..."

cd /tmp
wget https://aur.archlinux.org/cgit/aur.git/snapshot/aurget.tar.gz
tar xf aurget.tar.gz

cd aurget
makepkg -di
