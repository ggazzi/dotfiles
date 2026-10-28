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
Format: `- <active windows> · [[effort]] · <repository> · <sentence> · <session id, 8 chars>`. Claude writes every field but the effort link, which the vault's daily review inserts later. The repository is `owner/name` from the `origin` remote, else the directory path (`~` for home). Each entry covers only what happened since the session's previous entry, which is found by its session id; entries are kept sorted by first window start. Entries from before this format (span plus pauses, no session id) are left as written.
_Avoid_: activity (the vault's name for a reusable workflow step), session log, log line

**Active window**:
A stretch of a session with no gap over 15 minutes between messages, written `HH:MM–HH:MM`. A window crossing midnight is split (`23:40–24:00`, `00:00–00:20`), and the entry goes in the Daily note of its last message.
_Avoid_: span, pause (the old format's terms)
