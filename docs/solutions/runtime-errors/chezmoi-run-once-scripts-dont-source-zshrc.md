---
title: "chezmoi run_once_ scripts don't source .zshrc, so shell-activated tools aren't on PATH"
date: 2026-09-03
category: runtime-errors
module: chezmoi
problem_type: runtime_error
component: tooling
symptoms:
  - "A `run_once_*.sh.tmpl` script that calls `npm` (or any shell-activated tool) fails with \"command not found\" even though the shell's `.zshrc` activates it via an `eval \"$(... activate zsh)\"` line"
  - "The same command works fine when run manually from an interactive shell right after `chezmoi apply`"
root_cause: config_error
resolution_type: config_change
severity: high
tags: [chezmoi, run_once, proto, path, bootstrap]
---

# chezmoi run_once_ scripts don't source .zshrc, so shell-activated tools aren't on PATH

## Problem

A chezmoi `run_once_install-claude-code.sh.tmpl` script ran `npm install -g @anthropic-ai/claude-code` and worked in every manual test, but would fail on a genuinely fresh machine bootstrap.

## Symptoms

- `npm: command not found` (or any tool that's normally put on `$PATH` by a shell-rc `eval "$(... activate ...)"` line) inside a `run_once_` script
- No failure when testing the same script content by pasting it into an interactive terminal

## What Didn't Work

- Assuming "npm is available via the version manager, established elsewhere in this plan" was enough — a tool being configured (then mise's `~/.config/mise/config.toml`, now proto's `~/.proto/.prototools`) and being *on `PATH` in the current shell* are two different things.

## Solution

`run_once_` scripts execute non-interactively via chezmoi's own script runner — they never source `~/.zshrc` (or any rc file), so a PATH mutation that only happens via `eval "$(... activate zsh)"` in `.zshrc` never takes effect inside the script. Two fixes, applied together:

1. **Don't rely on shell activation inside the script.** Call the tool through its manager explicitly instead of assuming PATH. This repo's manager is proto (ADR 0002; this note was first written for mise):
   ```bash
   export PATH="$HOME/.proto/bin:$PATH"
   proto install --config-mode global      # installs the pins in ~/.proto/.prototools
   "$HOME/.proto/shims/npx" --yes skills --help
   ```
2. **Sequence real dependencies (mise, git-lfs, unzip, etc.) before `chezmoi apply` runs at all**, e.g. via `brew bundle`/`apt-get install` in the bootstrap docs — some run_once scripts (font install, apt install) depend on tools that must exist before `chezmoi apply` fires the very first time.

## Why This Works

The proto shim (or `proto run`) resolves the tool version for that one invocation without needing shell integration, so it's correct regardless of whether the calling context sourced any rc file. `proto install` defaults to `upwards` config mode, which skips the global `~/.proto/.prototools`; pass `--config-mode global`.

## Prevention

- Never assume a `run_once_` (or any chezmoi hook) script inherits shell-rc PATH mutations — treat it like a non-interactive cron job.
- When a `run_once_` script needs a manager-provided tool, invoke it through the manager (`~/.proto/shims/<tool>` or `proto run <tool> --`), not a bare call.
- Script order matters: chezmoi runs scripts in a phase sorted by target name, so a script that others depend on (the proto global install) is named `00-…`.
- Document bootstrap ordering explicitly (package managers before `chezmoi apply`) when a `run_once_` script assumes a tool is already installed.

## Related Issues
- [ADR 0002](../../adr/0002-proto-only-toolchain-manager.md), which replaced mise with proto.
