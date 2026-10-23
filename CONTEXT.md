# Dotfiles

Personal shell, editor and tool configuration, applied by chezmoi to the machines and containers I work in.

## Language

**Profile**:
The kind of environment the dotfiles are being applied to; decides which files and install steps apply. Either Workstation or Devcontainer.
_Avoid_: mode, flavor, target

**Workstation**:
A machine I own and use day to day (macOS, Linux, or Windows + WSL), where the dotfiles manage both configuration and the toolchain. On Windows + WSL, most configuration applies to the WSL side, but configuration for Windows-native tools (e.g. VS Code) applies to the Windows profile.
_Avoid_: host (ambiguous with Devcontainer Host), desktop

**Devcontainer**:
A development container started from a project's `devcontainer.json`, whose base image and toolchain belong to the project, not to the dotfiles.
_Avoid_: container (too broad), codespace (one Devcontainer Host's name for it)

**Devcontainer Host**:
The editor or service that creates a Devcontainer and runs the dotfiles bootstrap inside it: VS Code, the devcontainer CLI, Codespaces, or Zed.
_Avoid_: host (alone)

**Daily note**:
The Obsidian note for one day (`Daily/YYYY-MM-DD.md` in the vault), where I capture what happened that day.
_Avoid_: journal, daily page

**Work log entry**:
One line, written by Claude, recording what was done in a Claude Code session and when. Work log entries go in the Claude log section at the bottom of the Daily note. They are one of three independent time sources, alongside manual time tracking and git history, which are cross-referenced during reviews.
_Avoid_: activity (the vault's name for a reusable workflow step), session log
