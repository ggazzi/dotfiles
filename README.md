# Gui's Dotfiles

Dotfiles for two machines: a macOS laptop and an Ubuntu host. Managed with:

- **[chezmoi](https://www.chezmoi.io/)** — dotfiles, templated per-OS via `.chezmoi.os`. The chezmoi source root is the `chezmoi/` subdirectory (see `.chezmoiroot`), keeping dotfiles/templates/scripts separate from this repo's own config (`flake.nix`, `lib/`, `home/`, docs, package manifests).
- **Homebrew (`Brewfile`)** — macOS packages
- **apt (`apt-packages.txt` + `apt-packages-workstation.txt` or `apt-packages-devcontainer.txt`)** — Ubuntu packages; each package lives in exactly one list. Includes `mise`, whose official apt repo is registered by the install script itself (see below), since Ubuntu's default repos don't have it.
- **[mise](https://mise.jdx.dev/)** — global toolchain versions (Node, etc.). Installed via its official apt repo (registered by `run_onchange_00-install-apt-packages.sh.tmpl` before running `apt-get`), not the Brewfile-only curl installer.
- **[proto](https://moonrepo.dev/proto)** — per-project toolchain versions inside moonrepo projects only, via their own `.prototools`. Not globally shell-activated (deliberate — no `proto activate` line). `moon` invokes proto internally per-project; the `proto` binary just needs to be on `$PATH`. On macOS it comes from the Brewfile; on Linux (no apt package) it's installed by `run_once_install-proto.sh.tmpl` (moonrepo's official installer script, run with `--yes --no-modify-profile` so it stays non-interactive and doesn't touch shell profiles itself), and `~/.proto/bin` is added to `$PATH` directly by `dot_zshrc.tmpl` instead.
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
sed 's/#.*//' apt-packages.txt apt-packages-workstation.txt | xargs sudo apt-get install -y
```
`chezmoi` isn't in Ubuntu's apt repos, so it's installed via snap instead.

Symlink chezmoi's default source dir to wherever this repo is checked out, so
`init`/`apply`/`edit`/etc. all find it without passing `--source` every time:

```sh
ln -s "$(pwd)" ~/.local/share/chezmoi
chezmoi init
chezmoi apply
```

Existing Workstations must re-run `chezmoi init` once after pulling the
Devcontainer Profile change, so their config gains `devcontainer = false`
(templates reference it).

## Devcontainers

`install.sh` is the Devcontainer bootstrap and is never used on Workstations.
It installs chezmoi into `~/.local/bin` and applies this repo with the
Devcontainer Profile (`DOTFILES_PROFILE=devcontainer` sets chezmoi's
`.devcontainer` data). That Profile skips zed/mise/zellij configs, proto, the
Nerd Font and mise's apt repo, and installs `apt-packages.txt` +
`apt-packages-devcontainer.txt` instead of `apt-packages-workstation.txt`.
starship and Claude Code come from their official installers. It assumes an
Ubuntu-based image with root or passwordless sudo.

- **VS Code / devcontainer CLI / Codespaces**: set this repo as the dotfiles
  repository (VS Code: `dotfiles.repository = ggazzi/dotfiles`); they run
  `install.sh` automatically.
- **Zed**: has no dotfiles setting; run once in the container's terminal:
  ```sh
  git clone https://github.com/ggazzi/dotfiles ~/dotfiles && ~/dotfiles/install.sh
  ```

`install.sh` is safe to re-run. `sub` (and so `dev`) is skipped on aarch64
containers: there's no prebuilt binary.

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
