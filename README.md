# Gui's Nix Configs

These are my nix configurations.
If you're not me and are reading this, it might be useful, but I have no public ambitions with this repo.

This is heavily based on [EmergentMind's Nix Configs](https://github.com/EmergentMind/nix-config).

## Workflows

To update the versions of all dependencies:

```sh
nix flake update
```

To rebuild the nix-darwin configuration:

```sh
darwin-rebuild build --flake .
```

To apply the nix-darwin configuration (rebuilding if necessary):

```sh
sudo darwin-rebuild switch --flake .
```

The home-manager configuration gets built and applied together with the nix-darwin configuration.
