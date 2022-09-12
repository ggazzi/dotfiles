# Guilherme's NixOS Configuration

This is my personal NixOS configuration based on a flake.


It uses a set of custom Nix modules to abstract from NixOS and home-manager.
This is heavily based on [Jordan Isaac's dotfiles](https://github.com/jordanisaacs/dotfiles), as well as his very helpful [tutorial](https://jdisaacs.com/blog/nixos-config/) on how to do this.

## Updating

To update upstream software, update this flake by running `nix flake update` from this directory, then update the system according to the instructions below.

If the system configuration is changed or this flake has been updated, the actual system can be updated with the following command, run from this directory.

```sh
nixos-rebuild switch --flake .
```

For the user configuration and the corresponding software, use the following command.
It requires the `--impure` flag so it can read the system configuration from a file.

```sh
home-manager switch --flake . --impure
```

## Installation

1. Boot up an appropriate installation medium and [prepare the installation as usual](https://nixos.org/manual/nixos/stable/index.html#sec-installation), in particular by partitioning as you wish and mounting everything under `/mnt`.

2. Use `nixos-generate-config --root /mnt` to generate appropriate `configuration.nix` and `harware-configuration.nix` files under `/etc/nixos/`. Add the following to `configuration.nix`, and feel free to delete the graphical environment.

    ```nix
    {
        # ...

        nix = {
            # Allow usage of Flakes
            package = pkgs.nixFlakes;
            extraOptions = ''
                experimental-features = nix-command flakes
            '';

            # Save *a lot* of space
            autoOptimiseStore = true;
        };

        environment.systemPackages = with pkgs; [vim git];
    }
    ```

3. Prepare the configuration for the new system.

    - Choose a new hostname, set it in `/etc/nixos/configuration.nix`.

    - Clone this repository somewhere in the new system (you might need to run `nix-shell -p git`).

    - Copy `/etc/nixos/hardware-configuration.nix` into `hardware/<hostname>.nix`.

    - Create the new system configuration in `flake.nix`, adding an entry under `outputs.nixosConfigurations`.
      Don't forget to set `hardware`, `users` and `systemConfig` appropriately.

4. Install nix with a basic configuration by running `nixos-install` and set the root password.

5. Reboot into the new installation, log in as root and `cd` into this repository.

6. Apply this configuration to by running `nixos-rebuild switch --flake .`.

7. Log into each user, set their password and apply the configuration by running `home-manager switch --flake . --impure` from this directory.
