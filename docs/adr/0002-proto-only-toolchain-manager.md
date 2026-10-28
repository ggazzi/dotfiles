# proto is the only toolchain manager

proto manages every version-managed tool on Workstations: global tools (`~/.proto/.prototools`: node, pnpm, moon, bun, ...) and per-project pins (each project's `.prototools`). mise is not installed. `~/.proto/shims` and `~/.proto/bin` are on `PATH` statically for every zsh, prepended in `dot_zshenv.tmpl`.

This reverses the migration plan's R6/R7/R8 split (mise global, proto per-project). mise only ever managed Node LTS (and proto already held the other global pins), and the split broke as soon as both provided the same tool: in a proto project `pnpm` resolved to mise's shim and failed (#19). Making proto win per directory doesn't work, because Claude Code runs `zsh -c 'source <snapshot> && …'` and the snapshot's frozen `PATH` overwrites anything `.zshenv` computed, with no `cd` for a `chpwd` hook to react to. The Devcontainer Profile installs neither manager and keeps the image's tools.

## Consequences

- Shimmed tools are proto-only. proto has no "use system version" pin (`node = "system"` fails to resolve), so a shimmed tool proto lacks errors rather than falling back to Homebrew. Call a system binary by absolute path if ever needed.
- A shim exists only for the executables a plugin declares, which may not match the name callers use: proto's Python gives `python` and `pip`, never `python3`, so `python3` stays the system one. Callers that want the pinned Python call `python`. Check `ls ~/.proto/shims` after adding a tool.
- A tool outside proto's registry has no manager here. Revisit this ADR if one is needed.

## Considered Options

- **`PATH` sync on `cd` (ancestor walk for `.prototools`)**: rejected; unreachable from Claude Code shells (above).
- **`proto activate`**: rejected; same timing problem, and it prepends the shims even outside projects.
- **Dispatch wrappers (static `PATH`, choose proto or mise per call)**: rejected as heavy: a maintained name list and an extra exec per call.
