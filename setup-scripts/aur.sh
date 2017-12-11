#!/bin/bash

# Install wget
sudo pacman -S wget base-devel

# Install aurget
echo ""
echo "Installing aurget..."

cd /tmp || exit
[ -f aurget.tar.gz ] || wget https://aur.archlinux.org/cgit/aur.git/snapshot/aurget.tar.gz
tar xf aurget.tar.gz

cd aurget || exit
makepkg -di
