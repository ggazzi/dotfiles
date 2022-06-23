# Guilherme's NixOS Configuration

This is my personal NixOS configuration based on a flake.


It uses a set of custom Nix modules to abstract from NixOS and home-manager.
This is heavily based on [Jordan Isaac's dotfiles](https://github.com/jordanisaacs/dotfiles), as well as his very helpful [tutorial](https://jdisaacs.com/blog/nixos-config/) on how to do this.

## Updating

To update upstream software, update this flake by running `nix flake update` from this directory, then update the system according to the instructions below.

If the system configuration is changed or this flake has been updated, the actual system can be updated with the following command, run from this directory.

```sh
nixos-rebuild switch --flake '.#'
```

For the user configuration and the corresponding software, use the following command.
It requires the `--impure` flag so it can read the system configuration from a file.

```sh
home-manager switch --flake "$PWD" --impure
```

## Installation

1. Install NixOS normally on the new system, letting it generate the `configuration.nix` and `harware-configuration.nix` files under `/etc/nixos/`.

2. Prepare the configuration for the new system.

    - Choose a new hostname, set it in `/etc/nixos/configuration.nix` and apply it by running `nixos-rebuild test`.

    - Copy the `/etc/nixos/hardware-configuration.nix` into `hardware/<hostname>.nix`.

    - Create the new system configuration in `flake.nix`, adding an entry under `outputs.nixosConfigurations`.
      Don't forget to set `hadware`, `users` and `systemConfig` appropriately.

3. Apply this configuration to the system by running `nixos-rebuild switch --flake '.#'` from this directory.

4. Log into each user, set their password and apply the configuration by running `home-manager switch --flake "$PWD" --impure` from this directory.
