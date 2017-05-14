#!/bin/bash

sudo pacman -S cups ghostscript gsfonts

sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service

sudo systemctl enable cups-browsed.service
sudo systemctl start cups-browsed.service
