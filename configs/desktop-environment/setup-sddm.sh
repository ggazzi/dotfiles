# Installs and configures the display manager
# TODO: make this a package

echo
echo "Installing Display Manager..."

pacman -S sddm
aurget -S archlinux-themes-sddm --noedit

cp "$(realpath "$1/sddm.conf")" /etc/sddm.conf
