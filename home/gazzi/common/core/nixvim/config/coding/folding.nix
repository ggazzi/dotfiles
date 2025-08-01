{ lib, ... }:

{
  programs.nixvim = {

    plugins.treesitter.folding = true;
    opts = {
      foldlevel = 4;
      foldenable = false;
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>l";
        group = "Folding";
        icon = " ";
        mode = [
          "n"
          "v"
        ];
      }
    ];

    keymaps = lib.custom.nixvim.keymapGroup "<leader>l" [
      {
        key = "o";
        action = "zo";
        options.desc = "Open fold under cursor";
      }
      {
        key = "O";
        action = "zO";
        options.desc = "Open all folds under cursor";
      }
      {
        key = "c";
        action = "zc";
        options.desc = "Close fold under cursor";
      }
      {
        key = "C";
        action = "zC";
        options.desc = "Close all folds under cursor";
      }
      {
        key = "f";
        action = "za";
        options.desc = "Toggle fold under cursor";
      }
      {
        key = "F";
        action = "zA";
        options.desc = "Toggle all folds under cursor";
      }
      {
        key = "v";
        action = "zv";
        options.desc = "View cursor line";
      }
      {
        key = "r";
        action = "zx";
        options.desc = "Reset folds to foldlevel, keep cursor line visible";
      }
      {
        key = "R";
        action = "zX";
        options.desc = "Reset folds to foldlevel";
      }
      {
        key = "m";
        action = "zm";
        options.desc = "Fold more (decrease foldlevel)";
      }
      {
        key = "M";
        action = "zM";
        options.desc = "Fold everything (set foldlevel to 0)";
      }
      {
        key = "l";
        action = "zr";
        options.desc = "Fold less (increase foldlevel)";
      }
      {
        key = "L";
        action = "zR";
        options.desc = "Fold everything (set foldlevel to highest)";
      }
      {
        key = "t";
        action = "zi";
        options.desc = "Toggle folding";
      }
    ];
  };
}
