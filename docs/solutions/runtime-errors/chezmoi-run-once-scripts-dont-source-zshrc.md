---
title: "chezmoi run_once_ scripts don't source .zshrc, so shell-activated tools aren't on PATH"
date: 2026-09-03
category: runtime-errors
module: chezmoi
problem_type: runtime_error
component: tooling
symptoms:
  - "A `run_once_*.sh.tmpl` script that calls `npm` (or any shell-activated tool) fails with \"command not found\" even though the shell's `.zshrc` activates it via `eval \"$(mise activate zsh)\"`"
  - "The same command works fine when run manually from an interactive shell right after `chezmoi apply`"
root_cause: config_error
resolution_type: config_change
severity: high
tags: [chezmoi, run_once, mise, path, bootstrap]
---

# chezmoi run_once_ scripts don't source .zshrc, so shell-activated tools aren't on PATH

## Problem

A chezmoi `run_once_install-claude-code.sh.tmpl` script ran `npm install -g @anthropic-ai/claude-code` and worked in every manual test, but would fail on a genuinely fresh machine bootstrap.

## Symptoms

- `npm: command not found` (or any tool that's normally put on `$PATH` by a shell-rc `eval "$(... activate ...)"` line) inside a `run_once_` script
- No failure when testing the same script content by pasting it into an interactive terminal

## What Didn't Work

- Assuming "both OSes have npm via mise/nvm, established elsewhere in this plan" was enough — mise being configured (`~/.config/mise/config.toml`) and mise being *activated in the current shell* are two different things.

## Solution

`run_once_` scripts execute non-interactively via chezmoi's own script runner — they never source `~/.zshrc` (or any rc file), so a PATH mutation that only happens via `eval "$(mise activate zsh)"` in `.zshrc` never takes effect inside the script. Two fixes, applied together:

1. **Don't rely on shell activation inside the script.** Call the tool through the activator explicitly instead of assuming PATH:
   ```bash
   mise install
   mise exec -- npm install -g @anthropic-ai/claude-code
   ```
2. **Sequence real dependencies (mise, git-lfs, unzip, etc.) before `chezmoi apply` runs at all**, e.g. via `brew bundle`/`apt-get install` in the bootstrap docs — some run_once scripts (font install, apt install) depend on tools that must exist before `chezmoi apply` fires the very first time.

## Why This Works

`mise exec -- <cmd>` resolves and injects the mise-managed tool versions for that one invocation without needing shell integration, so it's correct regardless of whether the calling context sourced `.zshrc`.

## Prevention

- Never assume a `run_once_` (or any chezmoi hook) script inherits shell-rc PATH mutations — treat it like a non-interactive cron job.
- When a `run_once_` script needs a tool from mise/asdf/nvm, invoke it via `mise exec --`/the equivalent activator subcommand, not a bare call.
- Document bootstrap ordering explicitly (package managers before `chezmoi apply`) when a `run_once_` script assumes a tool is already installed.

## Related Issues
- None yet.
