#!/usr/bin/env bash

dotfile_dir="dotfiles"

# Allow '**' to recursively search for files when globbing
shopt -s globstar
# Allow globbing to find hidden files and directories
shopt -s dotglob

echo "Linking dotfiles..."
for dir in "$dotfile_dir"/*/
do
    name="$(basename "$dir")"
    echo "    $name"

    # Create directories so that stow only links files
    # (this avoids a lot of garbage being written into the repo)
    for path in "$dir"/**/*/
    do
        if [ "$path" =  "$dir/**/*" ]
        then
            # Globbing failed, no directories to create
            break
        fi
        mkdir -p "$HOME/${subdir#"$dir"}" 
    done

    # Link all dotfiles with stow
    stow -t "$HOME" -d "$dotfile_dir" "$(basename "$dir")"
done