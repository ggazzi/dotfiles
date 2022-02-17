# Guilherme's Linux Configuration

This repository contains my configuration files for NixOS, as well as utilities for setting it all up.

The whole thing is based on two utilities: [Home Manager](https://github.com/nix-community/home-manager) and [GNU stow](https://www.gnu.org/software/stow/).

- Home Manager is used mainly for specifying software that needs to be installed.
It is also used for 

## Dependencies

- Bash
- Git
- [GNU stow](https://www.gnu.org/software/stow/)
- [Home Manager](https://github.com/nix-community/home-manager).

Home Manager is used mainly for specifying software that needs to be installed.
It is also used for configs that are simple, mostly static and well-supported.
If I need to hack in the `nix` language to create files and such, for now I'd rather use `stow`.

Most of the configuration consists of files that will be managed by `stow`.
This means they will be symlinked instead of copied from this repository.
I prefer it this way, it makes tinkering much simpler, since I can change configs in-place.

## Installation

This is here mostly because I'm lazy don't want to think of it again.

1. Run `nix-shell -p git stow home-manager bash`.
2. Checkout this repository, `cd` to its root.
3. Run `./scripts/install-dotfiles.bash` to link all dotfiles.
4. Run `home-manager switch` to install any remaining software and configurations.
