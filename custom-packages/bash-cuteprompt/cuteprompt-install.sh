#!/bin/bash

# Create the bashrc if necessary
[ -f "$HOME/.bashrc" ] || touch "$HOME/.bashrc"

# Check if the script is already sourced by the bashrc
if ! grep -q '^source /usr/share/bash-cuteprompt/cuteprompt-set\.sh$' "$HOME/.bashrc"
then # Script is not yet sourced
	echo "source /usr/share/bash-cuteprompt/cuteprompt-set.sh" >> "$HOME/.bashrc"
fi
