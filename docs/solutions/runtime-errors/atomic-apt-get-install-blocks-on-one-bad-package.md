---
title: "A single unavailable apt package blocks the entire batch install"
date: 2026-09-03
category: runtime-errors
module: apt-packages
problem_type: runtime_error
component: tooling
symptoms:
  - "`xargs -a apt-packages.txt sudo apt-get install -y` installs nothing at all when even one package name in the list isn't in the configured repos"
  - "Packages that would have installed fine (curl, git, htop, ...) never land because they're bundled into the same apt-get invocation as an unresolvable package"
root_cause: config_error
resolution_type: config_change
severity: medium
tags: [apt, xargs, package-install, atomicity]
---

# A single unavailable apt package blocks the entire batch install

## Problem

An install script read a flat package list and ran `xargs -a apt-packages.txt sudo apt-get install -y`, passing every package name to one `apt-get install` invocation.

## Symptoms

- One package not in Ubuntu's default repos on a given release (e.g. `zellij`, `mise`, `lazygit` — anything shipped as a third-party binary/PPA rather than a stock apt package) causes the whole install to fail.
- Because `apt-get install` with multiple names is atomic, *every* package in the list — including the ones that would have installed fine — never gets installed either.

## What Didn't Work

- Listing every package in a single `apt-get install -y pkg1 pkg2 pkg3 ...` (or via `xargs -a file.txt apt-get install -y`, which produces the same batched call). This is correct for a curated, guaranteed-available package set, but not for a list assembled by porting packages from another package manager (e.g. migrating off nix), where availability per apt release isn't guaranteed for every entry.

## Solution

Install one package per `apt-get` invocation instead of batching the whole list:

```bash
# Before: one bad package blocks everything
xargs -a apt-packages.txt sudo apt-get install -y

# After: each package installs independently
xargs -a apt-packages.txt -n1 sudo apt-get install -y
```

`xargs -n1` runs the command once per input line instead of appending all lines to a single invocation.

## Why This Works

Each `apt-get install -y <one-package>` succeeds or fails independently, so one missing/renamed package only skips itself instead of aborting the batch.

## Prevention

- When a package list is ported from another source (nix, homebrew, a different distro) rather than hand-verified against the target repos, always install with `-n1` (or an equivalent per-package loop) rather than a single batched call.
- Document which packages in the list are known to be third-party/PPA-only so a failure for those specifically isn't a surprise.

## Related Issues
- None yet.

## Update (2026-09-03)

Reverted back to a single batched `apt-get install -y $(cat apt-packages.txt)`
call. The packages that originally motivated `-n1` (chezmoi, zellij, mise,
proto) were removed from `apt-packages.txt` or given their own apt repo
(mise) — every remaining entry is a genuine Ubuntu apt package, so batching
is safe again and atomicity becomes a feature: a regression (a package
silently dropped from Ubuntu's repos) now fails the whole install loudly
instead of `-n1` letting it install everything else and skip that one
silently.
