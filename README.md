# Gui's Nix Configs

These are my nix configurations.
If you're not me and are reading this, it might be useful, but I have no public ambitions with this repo.

This is heavily based on [EmergentMind's Nix Configs](https://github.com/EmergentMind/nix-config).

## Workflows

This repository includes a `justfile` with convenient commands that work on both Darwin and NixOS:

```sh
# Build configuration without applying (test your changes)
just build

# Build and apply configuration to current host
just apply

# Update all flake dependencies, test them, and commit flake.lock
just update

# Quick sync: update dependencies and apply in one go
just update apply
```

The `just` commands automatically:
- Detect your platform (Darwin/NixOS) and hostname
- Use the correct rebuild command for your system
- Handle `sudo` requirements with clear warnings
- Provide colored output to track progress
- Validate changes before committing (for `update`)

The home-manager configuration gets built and applied together with the nix-darwin configuration.
