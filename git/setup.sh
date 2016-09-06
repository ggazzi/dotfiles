#!/bin/bash

make_link()
{
  local name="$1"
  local target="$(realpath "$CONFIG_ROOT/$1")"
  local link_path="$2"

  if [ -f "$link_path" ] || [ -L "$link_path" ]
  then
      echo "backing up previous $name"
      mv "$link_path" "$link_path.prev"
  fi

  echo "linking $name"
  ln -s "$target" "$link_path"

  echo
}

CONFIG_ROOT="$1"

# Ensure git is installed
sudo pacman -S git gitg
echo

# Setup the configuration
make_link gitconfig "$HOME/.gitconfig"
