---
title: "Use .chezmoiroot to keep chezmoi's source tree separate from repo boilerplate"
date: 2026-09-03
category: tooling-decisions
module: chezmoi
problem_type: tooling_decision
component: tooling
severity: low
applies_when:
  - "A chezmoi source repo also contains non-dotfile content at the repo root (README, other tool configs, docs, unrelated project files) that shouldn't be treated as an apply target"
tags: [chezmoi, chezmoiroot, chezmoiignore, repo-layout]
---

# Use .chezmoiroot to keep chezmoi's source tree separate from repo boilerplate

## Context

When a chezmoi source repo lives at the repo root (`chezmoi init --source .`), *every* file in that root is a potential apply target unless explicitly excluded via `.chezmoiignore` — including files that have nothing to do with dotfiles (a `README.md`, a `flake.nix`, a `docs/` directory, etc.). Each of those has to be listed in `.chezmoiignore` by hand, and the list grows every time a new non-dotfile file lands at the repo root.

## Guidance

Add a `.chezmoiroot` file at the repo root containing the name of a subdirectory (e.g. `chezmoi`), and move all chezmoi-managed content (`dot_*`, `private_*`, `run_once_*`, `.chezmoi.toml.tmpl`, `.chezmoiignore` itself) into that subdirectory:

```
.chezmoiroot          # contains the single line "chezmoi"
chezmoi/
  .chezmoi.toml.tmpl
  .chezmoiignore
  dot_config/
  dot_gitconfig.tmpl
  private_dot_local/
  run_once_install-*.sh.tmpl
flake.nix              # untouched by chezmoi -- outside chezmoi/
README.md               # untouched by chezmoi -- outside chezmoi/
```

chezmoi reads `.chezmoiroot` before scanning and treats the named subdirectory as `chezmoi source-path`/`.chezmoi.sourceDir` — everything outside it is invisible to chezmoi entirely, no ignore entry needed.

## Why This Matters

Without `.chezmoiroot`, `.chezmoiignore` has to enumerate every non-dotfile path at the repo root, and forgetting one means chezmoi silently tries to apply it to `$HOME`. With `.chezmoiroot`, `.chezmoiignore` only needs entries for things that *are* inside the chezmoi subtree but still shouldn't be applied (e.g. a package manifest that lives alongside the dotfiles source but isn't itself a dotfile) — the boilerplate-exclusion list disappears.

## When to Apply

- Any chezmoi source repo that also holds non-dotfile content at its root (this repo, most "monorepo-style" dotfiles setups).
- Not needed for a repo whose sole purpose is chezmoi dotfiles with nothing else at the root — there's nothing to separate from.

## Examples

Verify the redirect took effect:

```sh
chezmoi source-path --source .
# => /path/to/repo/chezmoi   (not /path/to/repo)
```

`run_once_` scripts that need to reach *outside* the chezmoi subtree (e.g. a package manifest kept at repo root, not inside `chezmoi/`) use `{{ .chezmoi.sourceDir }}/../apt-packages.txt` — one `..` hop back out to the repo root.

## Related
- `docs/solutions/tooling-decisions/chezmoi-fabricated-os-override-for-cross-host-preview.md`
