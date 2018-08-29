#!/bin/bash

# Install emacs
sudo pacman -S emacs

# Install spell checking software
sudo pacman -S aspell aspell-de aspell-en aspell-pt

# Install isync/mbsync for fetching email, notmuch for reading email
sudo pacman -S isync notmuch
pip install --user notmuch
