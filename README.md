# Gui's Dotfiles

Dotfiles for two machines: a macOS laptop and an Ubuntu host. Managed with:

- **[chezmoi](https://www.chezmoi.io/)** — dotfiles, templated per-OS via `.chezmoi.os`. The chezmoi source root is the `chezmoi/` subdirectory (see `.chezmoiroot`), keeping dotfiles/templates/scripts separate from this repo's own config (`flake.nix`, `lib/`, `home/`, docs).
- **Homebrew (`chezmoi/Brewfile`)** — macOS packages
- **apt (`chezmoi/apt-packages.txt`)** — Ubuntu packages
- **[mise](https://mise.jdx.dev/)** — global toolchain versions (Node, etc.)
- **[proto](https://moonrepo.dev/proto)** — per-project toolchain versions inside moonrepo projects only, via their own `.prototools`. Not globally shell-activated (deliberate — see `chezmoi/dot_config/zsh/dot_zshrc.tmpl`, which has no `proto activate` line). `moon` invokes proto internally per-project; the `proto` binary just needs to be on `$PATH`, which the Brewfile/apt lockfile handle.
- **nixvim** (temporary) — `flake.nix` still builds neovim via a minimal standalone home-manager flake, since `home/gazzi/common/core/nixvim/` hasn't been ported to plain Lua yet. Everything else nix-related has been removed.

## Bootstrap

Install packages *before* `chezmoi apply` — the `run_once_` scripts chezmoi
runs during apply (nerd font, claude-code, apt packages) assume `mise`,
`git-lfs`, `unzip`, etc. are already on `$PATH`:

```sh
brew bundle --file=chezmoi/Brewfile              # macOS only
# or: xargs -a chezmoi/apt-packages.txt -n1 sudo apt-get install -y   # Ubuntu only

chezmoi init --source .
chezmoi apply
```

## Verification before a real apply

Two checks, per the plan's R14:

1. **Native host dry-run** — exercises the machine's real OS branch end-to-end, including `run_once_` script pending-state:
    ```sh
    chezmoi apply --dry-run --verbose
    ```

2. **Other host's template branch** — chezmoi only exercises the OS it's actually running on, so review the other host's rendering as text via a fabricated `.chezmoi.os` override (no second physical machine needed):
    ```sh
    chezmoi execute-template --source . --dry-run --override-data='{"chezmoi":{"os":"linux"}}' < some/template.tmpl
    # or, for the whole tree:
    chezmoi apply --dry-run --verbose --override-data='{"chezmoi":{"os":"linux"}}' --destination /tmp/chezmoi-preview
    ```
    (Swap `"linux"` for `"darwin"` when checking from the Ubuntu machine.)

Both should show only the expected file creates/`run_once_` scripts for the target OS, with no template errors, before running a real `chezmoi apply` against either live machine.
