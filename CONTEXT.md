# Dotfiles

Personal shell, editor and tool configuration, applied by chezmoi to the machines and containers I work in.

## Language

**Profile**:
The kind of environment the dotfiles are being applied to; decides which files and install steps apply. Either Workstation or Devcontainer.
_Avoid_: mode, flavor, target

**Workstation**:
A machine I own and use day to day (macOS or Linux/WSL), where the dotfiles manage both configuration and the toolchain.
_Avoid_: host (ambiguous with Devcontainer Host), desktop

**Devcontainer**:
A development container started from a project's `devcontainer.json`, whose base image and toolchain belong to the project, not to the dotfiles.
_Avoid_: container (too broad), codespace (one Devcontainer Host's name for it)

**Devcontainer Host**:
The editor or service that creates a Devcontainer and runs the dotfiles bootstrap inside it: VS Code, the devcontainer CLI, Codespaces, or Zed.
_Avoid_: host (alone)
