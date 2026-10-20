# Windows-native tool config is pushed from WSL

On a Windows + WSL Workstation, chezmoi runs only inside WSL. Config for tools that run natively on Windows, such as VS Code, is copied one-way into the Windows profile (`%APPDATA%`) by a `run_onchange_after_` script. Windows can't follow a symlink into the WSL filesystem, so a copy is the only option, and running chezmoi natively on Windows would mean porting every bash `run_*` script. As a result, edits made on the Windows side are overwritten on the next apply. Change the WSL source and re-apply instead.

## Considered Options

- **Native chezmoi on Windows**: rejected; every bash `run_*` script would need a Windows equivalent or a skip guard.
- **Symlink from the Windows profile into WSL**: impossible; Windows can't follow symlinks into the WSL filesystem.
- **VS Code Settings Sync**: rejected; it keeps the config outside this repo, so the Zed/VS Code equivalence rule can't be enforced.
