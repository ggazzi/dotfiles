#!/bin/bash

set +x

BASHRC_PATH="$(realpath "$1/bashrc")"

if [ -f ~/.bashrc ] || [ -L ~/.bashrc ]
then
    echo "backing up previous bashrc"
    mv ~/.bashrc ~/bashrc.prev
fi

echo "linking bashrc"
ln -s "$BASHRC_PATH" ~/.bashrc
