# Guilherme's NixOS Configuration

This is my personal NixOS configuration based on a flake.


It uses a set of custom Nix modules to abstract from NixOS and home-manager.
This is heavily based on [Jordan Isaac's dotfiles](https://github.com/jordanisaacs/dotfiles), as well as his very helpful [tutorial](https://jdisaacs.com/blog/nixos-config/) on how to do this.

## Updating

To update upstream software, update this flake by running `nix flake update` from this directory, then update the system according to the instructions below.

If the system configuration is changed or this flake has been updated, the actual system can be updated with the following command, run from this directory.

```sh
nixos-rebuild switch --flake path/to/this/flake
```

For the user configuration and the corresponding software, use the following command.
It requires the `--impure` flag so it can read the system configuration from a file.

```sh
home-manager switch --flake path/to/this/flake --impure
```

## Installation

1. Boot up an appropriate installation medium and [prepare the installation as usual](https://nixos.org/manual/nixos/stable/index.html#sec-installation), in particular by partitioning as you wish and mounting everything under `/mnt`.

2. Prepare this set of configurations for the new system.

    - Clone this repository somewhere in the new system (you might need to run `nix-shell -p git`).

    - Create the new system configuration in `flake.nix`, adding an entry under `outputs.nixosConfigurations` with the chosen hostname.
      Don't forget to set `hardware`, `users` and `systemConfig` appropriately.

    - Generate configuration for the hardware using `nixos-generate-config --root /mnt` and copy `/etc/nixos/hardware-configuration.nix` into `hardware/<hostname>.nix`.


3. Install the OS by running `nixos-install --flake path/to/this/flake#<hostname>`. You should be prompted for a root password.

4. Use `nixos-enter` to effectively `chroot` into the newly installed nixos and set the passwords for the desired users (`passwd <username>`).

5. Reboot into the new installation and apply the configuration of each desired user by running `home-manager switch --flake path/to/this/flake --impure` as the desired user.

### Doom Emacs

Since Doom Emacs has its own package manager that doesn't necessarily play well with nix, each user has to install it manually.
It will need a configuration file, however, that **is** managed by home-manager in this flake.
The following instructions will help you install it and apply the configuration.

1. Make sure that Emacs is enabled for this user in `flake.nix` and that this was applied by `home-manager`.

2. Install Doom Emacs [as usual](https://github.com/doomemacs/doomemacs#install). The required environment variables will have been set by `home-manager`.
