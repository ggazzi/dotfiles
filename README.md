# Gui's Dotfiles

Dotfiles for two machines: a macOS laptop and an Ubuntu host. Managed with:

- **[chezmoi](https://www.chezmoi.io/)** — dotfiles, templated per-OS via `.chezmoi.os`. The chezmoi source root is the `chezmoi/` subdirectory (see `.chezmoiroot`), keeping dotfiles/templates/scripts separate from this repo's own config (`flake.nix`, `lib/`, `home/`, docs, package manifests).
- **Homebrew (`Brewfile`)** — macOS packages
- **apt (`apt-packages.txt`)** — Ubuntu packages. Includes `mise`, whose official apt repo is registered by the install script itself (see below), since Ubuntu's default repos don't have it.
- **[mise](https://mise.jdx.dev/)** — global toolchain versions (Node, etc.). Installed via its official apt repo (registered by `run_onchange_00-install-apt-packages.sh.tmpl` before running `apt-get`), not the Brewfile-only curl installer.
- **[proto](https://moonrepo.dev/proto)** — per-project toolchain versions inside moonrepo projects only, via their own `.prototools`. Not globally shell-activated (deliberate — no `proto activate` line). `moon` invokes proto internally per-project; the `proto` binary just needs to be on `$PATH`. On Linux it's installed via `run_onchange_00-install-apt-packages.sh.tmpl` (moonrepo's official installer script, run with `--yes --no-modify-profile` so it stays non-interactive and doesn't touch shell profiles itself) and `~/.proto/bin` is added to `$PATH` directly by `dot_zshrc.tmpl` instead.
- **zellij** — not in Ubuntu's apt repos either; not currently installed by any script. Install manually (`cargo install zellij`, or a release binary from GitHub) if you want it on the Ubuntu machine.
- **nixvim** (temporary) — `flake.nix` still builds neovim via a minimal standalone home-manager flake, since `home/gazzi/common/core/nixvim/` hasn't been ported to plain Lua yet. Everything else nix-related has been removed.

## Dependencies

Install manually before bootstrapping — it *is* the package manager, so it
can't be tracked in the Brewfile it's used to install:

- **Homebrew** (macOS only) — [brew.sh install script](https://brew.sh)

## Bootstrap

Install system packages first, which includes `chezmoi` itself and anything the `run_once_` scripts need.

- On macOS:
```sh
brew bundle --file=Brewfile
```

- On Ubuntu/Debian:
```sh
sudo snap install chezmoi --classic
xargs -a apt-packages.txt -n1 sudo apt-get install -y
```
`chezmoi` isn't in Ubuntu's apt repos, so it's installed via snap instead.

Symlink chezmoi's default source dir to wherever this repo is checked out, so
`init`/`apply`/`edit`/etc. all find it without passing `--source` every time:

```sh
ln -s "$(pwd)" ~/.local/share/chezmoi
chezmoi init
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
