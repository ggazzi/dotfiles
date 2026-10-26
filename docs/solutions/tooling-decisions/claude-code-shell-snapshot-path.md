---
title: "Claude Code runs commands from a shell snapshot that freezes the launching process's PATH"
date: 2026-10-26
category: tooling-decisions
module: shell
problem_type: tooling_decision
component: tooling
severity: medium
applies_when:
  - "Making a tool or version manager reachable from Claude Code shells (PATH set in .zshenv/.zshrc, chpwd hooks, per-directory activation)"
  - "Testing a shell or PATH change from inside a Claude Code session"
tags: [claude-code, zsh, path, zshenv, zdotdir, proto]
---

# Claude Code runs commands from a shell snapshot that freezes the launching process's PATH

## Context

Each Bash tool call runs as `zsh -c 'source <snapshot> && eval <command>'`. The snapshot (`~/.claude/shell-snapshots/snapshot-zsh-*.sh`) contains an `export PATH=…` line, which is the `PATH` of the process that launched `claude`, not one recomputed by zsh startup.

## Consequences

- A `PATH` computed per directory (an ancestor walk in `.zshenv`, a `chpwd` hook, `proto activate`, `mise activate`) never takes effect in Claude Code: the snapshot overwrites it, and there is no `cd`, so hooks never fire. A version manager's precedence must be a **static** `PATH` entry (this repo: `dot_zshenv.tmpl`, ADR 0002).
- The static entry must already be on `PATH` where `claude` starts (any terminal that read `~/.zshenv`). A launcher that skips zsh startup does not get it.

## Testing a PATH change from inside a session

An existing session's snapshot is stale, so launch a fresh headless session, with a minimal `PATH` and without the inherited `ZDOTDIR` (when `ZDOTDIR` is exported, a child zsh reads `$ZDOTDIR/.zshenv`, not `~/.zshenv`, and skips it):

```bash
P='Use the Bash tool to run exactly: command -v moon pnpm node; node --version. Then print its raw output and nothing else.'
export P
PATH=/usr/bin:/bin:/opt/homebrew/bin /usr/bin/env -u ZDOTDIR /bin/zsh -c 'claude -p "$P" --allowedTools Bash --model haiku'
```

- Put the prompt in an environment variable; nested quoting made the model skip the command.
- `env -i` drops the login, so `claude` reports "Not logged in"; strip only `PATH`.

## Before chezmoi-managing an existing file

Run `chezmoi diff --source .` and read the live target first. `~/.proto/.prototools` already held the global pins (the file is **not** `~/.prototools`), and a managed `node = "lts"` would have replaced them. Tools that edit dotfiles themselves (rustup appends to `~/.zshenv`) also make `chezmoi apply` stop with "has changed since chezmoi last wrote it"; put the tool's line in the template.
