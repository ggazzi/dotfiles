#!/usr/bin/env bash
# Devcontainer bootstrap only -- Devcontainer Hosts (VS Code, devcontainer CLI,
# Codespaces) run this after cloning the repo. Workstations use chezmoi
# directly; see README. Safe to re-run.
set -euo pipefail

# Devcontainer Hosts only show output once this exits; follow progress live
# with `tail -f ~/.dotfiles-install.log` from a container terminal.
exec > >(tee "$HOME/.dotfiles-install.log") 2>&1

export DOTFILES_PROFILE=devcontainer
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" \
    init --apply --source "$(cd "$(dirname "$0")" && pwd)"
echo "==> dotfiles: done"
