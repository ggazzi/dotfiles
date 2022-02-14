#!/bin/bash

sudo pacman -S nvidia bumblebee bbswitch mesa-demos

USER="$(whoami)"
sudo gpasswd -a "$USER" bumblebee

sudo systemctl enable bumblebeed
