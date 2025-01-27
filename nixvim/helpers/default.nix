{
  keymapGroup = prefix: keymaps:
    let
      adaptKeymap = { key, ... }@keymap:
        keymap // { key = "${prefix}${key}"; };
    in
    builtins.map adaptKeymap keymaps;

  keymapToggles = import ./keymapToggles.nix;
}
