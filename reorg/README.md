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
darwin-rebuild switch --flake .
```

To rebuild the home-manager configuration:

```sh
home-manager build --flake .
```

To apply the home-manager configuration (rebuilding if necessary):

```sh
home-manager switch --flake .
```
