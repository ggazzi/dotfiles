---
title: "Audit every consumer of a dependency before dropping it, not just its declaration"
date: 2026-09-03
category: workflow-issues
module: dev-utils
problem_type: workflow_issue
component: development_workflow
severity: high
applies_when:
  - "Removing or replacing a third-party tool/library that other scripts or code depend on implicitly (an env var it sets, a calling convention it establishes, a helper it exposes) rather than through an explicit, typed interface"
tags: [migration, dependency-removal, code-review, implicit-contract]
---

# Audit every consumer of a dependency before dropping it, not just its declaration

## Context

A migration replaced a third-party CLI dispatcher tool ("sub") with a small hand-written replacement covering the same surface command (`dev <namespace> <command>`). The replacement correctly dispatched to the right script, but the original tool also populated an environment variable (`_DEV_ARGS`) from each script's `Usage:`/`Options:` header comments before invoking it — an implicit contract three consumer scripts silently depended on (`declare -A args="($_DEV_ARGS)"`). Nothing in the dispatcher's own code or tests referenced those three scripts, so the gap wasn't visible from the dispatcher's side at all.

## Guidance

When dropping or replacing a dependency, grep for every place that dependency's *side effects* are consumed — not just where it's installed or invoked. A dependency's real interface is often wider than its command-line surface: environment variables it sets, files it generates, naming conventions it enforces, or DSLs its own child scripts assume are being parsed for them.

```bash
# Not enough: check where the tool itself is called
grep -rn "sub\b" .

# Needed: check what its *consumers* assume it already did for them
grep -rln "_DEV_ARGS" .
```

A manual smoke test of the dispatcher itself ("does `dev pj list` work?") won't catch this — the break only shows up in scripts that use the implicit contract, which may be a subset of all consumers.

## Why This Matters

The regression here shipped past manual testing and was only caught by a dedicated code review pass looking specifically at correctness across the diff — not by running the migrated tooling. Implicit contracts are exactly the kind of thing that "it still runs" testing misses, because the happy path (the dispatcher resolving and exec'ing the right script) works fine; only the *content* of what gets passed to the child script is silently wrong or empty.

## When to Apply

- Any time a tool, library, or framework is removed/replaced during a migration or dependency cleanup.
- Especially when the tool being removed was a code-generation, wrapping, or dispatching layer (build tools, CLI dispatchers, codegen, ORMs) rather than a leaf-level utility — those are the ones most likely to have implicit side-channel contracts with their consumers.

## Examples

Before (three scripts silently depend on `sub`'s header-parsed `_DEV_ARGS`):

```bash
declare -A args="($_DEV_ARGS)"
project="${args[project]}"
```

After (once the dependency's real contract was identified, the fix was to stop relying on it rather than reimplement it):

```bash
project="$1"
```

## Related
- None yet.
