install_package()
{
  cd "$1"
  makepkg -i
  cd -
}

# Ensure base-devel is installed
sudo pacman -S base-devel

# Install the packages
for item in ./*
do
  if [ -d "$item" ]
  then
    cd "$item"
    makepkg -i
    cd ..
  fi
done

# Install aurget
cd /tmp
wget https://aur.archlinux.org/cgit/aur.git/snapshot/aurget.tar.gz
tar xf aurget.tar.gz

cd aurget
makepkg -i
