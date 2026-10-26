# Gui's Dotfiles

Dotfiles for two machines: a macOS laptop and an Ubuntu host. Managed with:

- **[chezmoi](https://www.chezmoi.io/)** — dotfiles, templated per-OS via `.chezmoi.os`. The chezmoi source root is the `chezmoi/` subdirectory (see `.chezmoiroot`), keeping dotfiles/templates/scripts separate from this repo's own config (`flake.nix`, `lib/`, `home/`, docs, package manifests).
- **Homebrew (`Brewfile`)** — macOS packages
- **apt (`apt-packages.txt` + `apt-packages-workstation.txt` or `apt-packages-devcontainer.txt`)** — Ubuntu packages; each package lives in exactly one list.
- **[proto](https://moonrepo.dev/proto)** — the only toolchain manager: global tools (pinned in `~/.proto/.prototools`, installed by `run_onchange_after_00-install-proto-tools.sh.tmpl`) and per-project versions via each project's `.prototools`. `dot_zshenv.tmpl` puts `~/.proto/shims` and `~/.proto/bin` on `$PATH` for every zsh (static, so it also survives Claude Code's shell snapshot; `dot_zprofile.tmpl` re-prepends them after `brew shellenv` on macOS). Shimmed tools (`node`, `npm`, `pnpm`, `bun`, `moon`, …) are proto-only: proto has no "use system version" pin, so a tool it doesn't have installed errors instead of falling back to Homebrew. See `docs/adr/0002-proto-only-toolchain-manager.md`. On macOS it comes from the Brewfile; on Linux (no apt package) it's installed by `run_once_install-proto.sh.tmpl` (moonrepo's official installer script, run with `--yes --no-modify-profile` so it stays non-interactive and doesn't touch shell profiles itself).
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
`.devcontainer` data). That Profile skips zed/VS Code/zellij configs, proto, the
Nerd Font, and installs `apt-packages.txt` +
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

### Monitoring the install

Devcontainer Hosts only show `install.sh` output once it finishes (VS Code:
the "Dev Containers" output channel). It also tees everything to
`~/.dotfiles-install.log`, with a `==> dotfiles: …` header per step. Follow it
live while the container is still configuring:

- From a terminal inside the container (VS Code allows opening one during
  "Configuring Dev Container"):
  ```sh
  tail -F ~/.dotfiles-install.log
  ```
- From the Docker host, even before any terminal is available (`docker ps -lq`
  is the most recently created container; check `docker ps` if several are
  starting; `-u` must be the container user, so `~` is their home):
  ```sh
  docker exec -it -u <user> $(docker ps -lq) sh -c 'tail -F ~/.dotfiles-install.log'
  ```

`-F` waits for the file to appear if `install.sh` hasn't started yet.

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
