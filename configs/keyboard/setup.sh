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


CONFIG_ROOT="$(realpath "$1")"

make_link XCompose "$HOME/.XCompose"

mkdir -p "$HOME/.bashrc.d"
make_link bashrc_ibus "$HOME/.bashrc.d/0_ibus"
