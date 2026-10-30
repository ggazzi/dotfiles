---
title: "proto shims only the executables its plugin declares (Python: `python`, not `python3`)"
date: 2026-10-28
category: tooling-decisions
module: proto
problem_type: tooling_decision
component: tooling
severity: medium
applies_when:
  - "Adding a tool to proto's global or per-project pins and expecting callers to keep invoking it by a name they already use"
  - "Planning around which binary a name resolves to before the tool is installed"
tags: [proto, python, shims, path]
---

# proto shims only the executables its plugin declares

## Context

The Obsidian vault calls `python3` everywhere. Pinning `python = "3.15.2"` in `~/.proto/.prototools` (#30) was meant to give every Workstation the same Python. After `proto install`, `command -v python3` still resolved to the old Python (mise's shim on macOS; it would be `/usr/bin/python3` once mise goes), and only `python` resolved to `~/.proto/shims`.

## Guidance

A proto shim exists only for the executables the tool's plugin declares. proto's Python plugin declares `python` and `pip`: `~/.proto/shims` gets `python`, `python-3`, `python-3.15` and `pip`, and `~/.proto/bin` gets `python`. There is never a `python3`, even though the installed tool directory has one.

So the caller adapts: the vault switched its scripts and skills from `python3` to `python` (ggazzi/dev-notes a92bd7a). Linking `python3` into `~/.proto/bin` by hand was rejected: proto owns that directory.

Nothing reveals the shim names before install: `proto plugin info python` errors until the tool is installed. Install, then check:

```sh
ls ~/.proto/shims ~/.proto/bin
```

## Why This Matters

A missing shim fails silently: the name falls through to whatever is next on `PATH`, so callers keep running a different version with no error.

## Related

- `docs/adr/0002-proto-only-toolchain-manager.md`
- #30
