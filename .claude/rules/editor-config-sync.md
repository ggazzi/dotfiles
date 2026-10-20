---
paths:
  - "chezmoi/dot_config/zed/**"
  - "chezmoi/dot_config/Code/**"
---

# Keep Zed and VS Code configs equivalent

Zed (`chezmoi/dot_config/zed/`) and VS Code (`chezmoi/dot_config/Code/User/`) must give the same editing experience. Neither is canonical.

- Changing a setting or keybinding in one editor: make the equivalent change in the other in the same commit.
- A setting with no equivalent in the other editor: leave a comment next to it saying `no equivalent` in the other editor and why.
- Adding a VS Code extension that the config depends on: add it to `EXTENSIONS` in `chezmoi/run_onchange_after_install-vscode.sh.tmpl`.
