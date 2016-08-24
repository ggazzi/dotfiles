#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Use Vim as default command-line editor
export EDITOR=vim
export VISUAL=vim

# Colorize the prompt (requires the cuteprompt package)
source /usr/share/bash-cuteprompt/cuteprompt-set.sh

# Sets up the path
PATH=$HOME/.local/bin:$PATH

# Useful aliases
alias open=xdg-open


# Sources everything from ~/.bashrc.d
if [ -d ~/.bashrc.d ]
then
  for file in ~/.bashrc.d/*
  do
    if [ -f "$file" ]
    then
      source $file
    fi
  done
fi
