# Nix configuration

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
