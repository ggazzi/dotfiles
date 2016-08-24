# Installs and configures the desktop environment

echo
echo "Installing Cinnamon"
sudo pacman -S cinnamon


echo
echo "Installing themes"
sudo pacman -S faenza-icon-theme faience-icon-theme otf-fira-mono otf-fira-sans
aurget -S gtk-theme-arc ttf-roboto ttf-roboto-mono otf-fira-code otf-hasklig --noedit


echo
echo "Installing utilities"
sudo pacman -S file-roller gnome-terminal gedit firefox system-config-printer


echo
echo "Configuring Cinnamon"
dconf load /org/cinnamon < cinnamon.conf
