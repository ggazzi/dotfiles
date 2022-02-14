#!/bin/bash

# Install emacs
sudo pacman -S emacs

# Install doom emacs
git clone --depth 1 https://https://github.com/hlissner/doom-emacs ~/.emacs.d
.emacs.d/bin/doom install
