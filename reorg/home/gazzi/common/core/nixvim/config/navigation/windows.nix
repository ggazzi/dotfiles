{ lib, ... }:

{
  programs.nixvim = {

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>w";
        group = "Window";
        mode = [
          "n"
          "v"
        ];
      }
    ];

    keymaps = lib.custom.nixvim.keymapGroup "<leader>w" [
      {
        key = "s";
        action = ":split<CR>";
        options.desc = "Split window horizontally";
      }
      {
        key = "v";
        action = ":vsplit<CR>";
        options.desc = "Split window vertically";
      }
      {
        key = "h";
        action = "<C-w>h";
        options.desc = "Jump to window on the left";
      }
      {
        key = "j";
        action = "<C-w>j";
        options.desc = "Jump to window below";
      }
      {
        key = "k";
        action = "<C-w>k";
        options.desc = "Jump to window above";
      }
      {
        key = "l";
        action = "<C-w>l";
        options.desc = "Jump to window on the right";
      }
      {
        key = "H";
        action = "<C-w>H";
        options.desc = "Swap window with next to the left";
      }
      {
        key = "J";
        action = "<C-w>J";
        options.desc = "Swap window with next below";
      }
      {
        key = "K";
        action = "<C-w>K";
        options.desc = "Swap window with next above";
      }
      {
        key = "L";
        action = "<C-w>L";
        options.desc = "Swap window with next to the right";
      }
      {
        key = "p";
        action = "<C-w>p";
        options.desc = "Jump to previous (last accessed) window";
      }
      {
        key = "q";
        action = "<C-w>q";
        options.desc = "Close current window";
      }
      {
        key = "=";
        action = "<C-w>=";
        options.desc = "Equalize size of windows";
      }
      {
        key = "-";
        action = "<C-w>-";
        options.desc = "Decrease window height";
      }
      {
        key = "+";
        action = "<C-w>+";
        options.desc = "Increase window height";
      }
      {
        key = "<";
        action = "<C-w><lt>";
        options.desc = "Decrease window height";
      }
      {
        key = ">";
        action = "<C-w>>";
        options.desc = "Increase window height";
      }
    ];
  };
}
