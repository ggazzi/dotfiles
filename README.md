# Guilherme's NixOS Configuration

This is my personal NixOS configuration based on a flake.


It uses a set of custom Nix modules to abstract from NixOS and home-manager.
This is heavily based on [Jordan Isaac's dotfiles](https://github.com/jordanisaacs/dotfiles), as well as his very helpful [tutorial](https://jdisaacs.com/blog/nixos-config/) on how to do this.

## Updating

If the system configuration is changed, the system can be updated with the following command, run from this directory.

```bash
nixos-rebuild switch --flake '.#'
```

## Installation

This is here mostly because I'm lazy don't want to think of it again.

1. Run `nix-shell -p git stow home-manager bash`.
2. Checkout this repository, `cd` to its root.
3. Run `./scripts/install-dotfiles.bash` to link all dotfiles.
4. Run `home-manager switch` to install any remaining software and configurations.
