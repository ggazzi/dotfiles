#!/bin/bash
# shellcheck source=/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Use Vim as default command-line editor
export EDITOR=vim
export VISUAL=vim

# Colorize the prompt (requires the cuteprompt package)
source /usr/share/bash-cuteprompt/cuteprompt-set.sh

# Set up the path
PATH=$HOME/.local/bin:$PATH

# Allow '**' to recursively search for files when globbing
shopt -q globstar

# Useful aliases
alias open="gio open"


# Source everything from ~/.bashrc.d
if [ -d ~/.bashrc.d ]
then
  for file in ~/.bashrc.d/*
  do
    if [ -f "$file" ]
    then
      source "$file"
    fi
  done
fi
