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

The home-manager configuration gets built and applied together with the nix-darwin configuration.

## Automatic Updates

This configuration includes automatic updates that run weekly on all hosts:

- **What it does**: Updates flake dependencies, validates the configuration, and applies changes automatically
- **Schedule**: Runs weekly according to a schedule (or on the next system startup, if the system is off during the scheduled time)
- **Platforms**: Works on both Darwin (using launchd) and NixOS (using systemd)

The auto-update schedule is configured in [`hosts/common/core/default.nix`](hosts/common/core/default.nix):

### Monitoring

**On Darwin (macOS):**
```sh
# Check if service is loaded
sudo launchctl list | grep dotfiles-auto-update

# View output logs
sudo tail -f /var/log/dotfiles-update.log

# View error logs
sudo tail -f /var/log/dotfiles-update-error.log
```

**On NixOS:**
```sh
# Check service status
systemctl status dotfiles-auto-update.service

# Check timer status and next run
systemctl list-timers dotfiles-auto-update.timer

# View logs
journalctl -u dotfiles-auto-update.service
```
