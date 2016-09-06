# Installs and configures the display manager
# TODO: make this a package

echo
echo "Installing xorg drivers (choose the relevant ones)"

sudo pacman -S xorg-drivers

echo
echo "Installing Xorg"

sudo pacman -S xorg-server xorg-server-utils

echo
echo "Installing Display Manager..."

sudo pacman -S sddm
aurget -S archlinux-themes-sddm --noedit

sudo cp "$(realpath "$1/config/sddm.conf")" /etc/sddm.conf
