#!/bin/bash


echo
echo "Installing texlive"
sudo pacman -S texlive-{bibtexextra,bin,core,fontsextra,formatsextra,langextra,latexextra,pictures,science} biber

echo "Installing auctex"
sudo pacman -S auctex
