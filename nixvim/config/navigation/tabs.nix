{ mylib, ... }:

{
  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>T"; group = "Tabs"; }
  ];

  keymaps = mylib.keymapGroup "<leader>T" [
    { key = "n"; action = ":tabnew<CR>"; options.desc = "New tab"; }
    { key = "c"; action = ":tabclose<CR>"; options.desc = "Close tab"; }
    { key = "o"; action = ":tabonly<CR>"; options.desc = "Close all other tabs"; }
    { key = "h"; action = ":tabprevious<CR>"; options.desc = "Previous tab"; }
    { key = "l"; action = ":tabnext<CR>"; options.desc = "Next tab"; }
  ];
}
