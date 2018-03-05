#!/bin/bash

echo
echo "Installing ghc, cabal-install and stack"
sudo pacman -S ghc cabal-install stack

echo
echo "Installing auxiliary tools"
sudo pacman -S hlint
