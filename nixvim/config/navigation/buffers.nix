{ mylib, ... }:

{
  plugins.vim-bbye.enable = true;

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>b";
      group = "Buffer";
    }
  ];

  keymaps = mylib.keymapGroup "<leader>b" [
    {
      key = "c";
      action = ":let @+=expand(\"%\")<CR>";
      options = { desc = "Copy relative filename to clipboard"; silent = false; };
    }
    {
      key = "C";
      action = ":let @+=expand(\"%:p\")<CR>";
      options = { desc = "Copy absolute filename to clipboard"; silent = false; };
    }
    { key = "d"; action = ":Bwipeout<CR>"; options.desc = "Wipeout current buffer keeping window layout"; }
    { key = "l"; action = ":b#<CR>"; options.desc = "Switch to last used buffer"; }
    { key = "o"; action = ":%bd \\| :e #<CR>"; options.desc = "Close all other buffers"; }
    { key = "D"; action = ":bwipeout<CR>"; options.desc = "Wipeout current buffer"; }
  ];
}
