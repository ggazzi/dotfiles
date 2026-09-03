---
title: "Preview chezmoi's other-host template branch without owning a second machine"
date: 2026-09-03
category: tooling-decisions
module: chezmoi
problem_type: tooling_decision
component: tooling
severity: medium
applies_when:
  - "A chezmoi source tree templates behavior differently per `.chezmoi.os` (or any other builtin/data variable), and you need to verify the branch for an OS you aren't currently running before applying it on a live machine"
tags: [chezmoi, templates, cross-platform, verification, dry-run]
---

# Preview chezmoi's other-host template branch without owning a second machine

## Context

A dotfiles repo managed two machines (macOS + Ubuntu) from one chezmoi source tree, branching on `.chezmoi.os`. `chezmoi apply --dry-run` only exercises the OS chezmoi is actually running on — it can't show what the *other* host's branch would render, and there was no second physical machine on hand to check it against.

## Guidance

Pass `--override-data` with a fabricated `chezmoi` data object to force chezmoi to evaluate templates as if it were running on a different OS:

```sh
# From a macOS machine, preview what the Linux branch would apply/render:
chezmoi apply --dry-run --verbose \
  --override-data='{"chezmoi":{"os":"linux"}}' \
  --destination /tmp/chezmoi-preview

# Or render a single template file directly:
chezmoi execute-template --init --source . \
  --override-data='{"chezmoi":{"os":"linux"}}' \
  '{{ .chezmoi.os }}'
```

Any field under `.chezmoi` (not just `os`) can be overridden this way — `arch`, `hostname`, etc. — which also lets you fabricate a `.chezmoiignore`-conditional scenario for a specific hostname without renaming your actual machine.

## Why This Matters

Without this, the only way to verify an OS-conditional template branch is to actually own or provision that OS, which is often unavailable (no second machine, no VM set up yet) exactly when you most need to check it — right before a real `chezmoi apply` that could otherwise silently apply the wrong branch or, worse, skip a file it should have created.

## When to Apply

- Before a first real `chezmoi apply` on a newly-added OS branch, to catch template errors and confirm conditional file inclusion/exclusion without touching a live machine.
- As a repeatable pre-flight check documented alongside the native-host `--dry-run` step (see this repo's README "Verification before a real apply" section).

## Examples

Confirming a darwin-only file is correctly excluded on the Linux branch:

```sh
chezmoi apply --dry-run --verbose \
  --override-data='{"chezmoi":{"os":"linux"}}' \
  --destination /tmp/chezmoi-preview 2>&1 | grep -c 'alacritty'
# => 0, confirming the darwin-only alacritty config never renders on the linux branch
```

## Related
- `docs/solutions/tooling-decisions/chezmoiroot-subdirectory-separation.md`
