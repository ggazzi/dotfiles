#!/bin/sh
# Devcontainer bootstrap only -- Devcontainer Hosts (VS Code, devcontainer CLI,
# Codespaces) run this after cloning the repo. Workstations use chezmoi
# directly; see README. Safe to re-run.
set -eu

export DOTFILES_PROFILE=devcontainer
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" \
    init --apply --source "$(cd "$(dirname "$0")" && pwd)"
