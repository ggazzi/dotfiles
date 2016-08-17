#!/bin/bash

create_config_link()
{
    local file="$1"
    local link_path="$HOME/.atom/$file"
    local tgt_path="$CONFIG_ROOT/$file"

    if [ -e "$link_path" ]
    then
      echo "saving copy of $file"
      mv "$link_path" "$link_path.prev"
    elif [ -L "$link_path" ]
    then
      echo "removing previous link of $file"
      rm "$link_path"
    fi

    echo "linking $file"
    ln -s "$tgt_path" "$link_path"
  }

# Get the parameters
CONFIG_ROOT="$(realpath "$1")"

if [ -z "$2" ]
then
  ATOM_ROOT=~/.atom/
else
  ATOM_ROOT="$(realpath "$2")"
fi

# Link to the config files
create_config_link "config.cson"
create_config_link "packages.cson"
create_config_link "styles.less"

# Install minimal necessary packages
echo "Installing package-sync"
apm install package-sync
