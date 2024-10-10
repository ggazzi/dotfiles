{ mylib, ... }:

{
  plugins.telescope.enable = true;

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>f";
      group = "Find (fuzzy)";
    }
  ];

  keymaps = mylib.keymapGroup "<leader>f" [
    { key = "b"; action = ":Telescope buffers<CR>"; options.desc = "Find buffer"; }
    { key = "c"; action = ":Telescope commands<CR>"; options.desc = "Find command"; }
    { key = "d"; action = ":Telescope diagnostics<CR>"; options.desc = "Find diagnostics"; }
    { key = "f"; action = ":Telescope find_files hidden=true<CR>"; options.desc = "Find files"; }
    { key = "g"; action = ":Telescope live_grep<CR>"; options.desc = "Find files"; }
    { key = "h"; action = ":Telescope help_tags<CR>"; options.desc = "Find help tags"; }
    { key = "m"; action = ":Telescope keymaps<CR>"; options.desc = "Find keymaps"; }
    { key = "/"; action = ":Telescope current_buffer_fuzzy_find<CR>"; options.desc = "Find in current buffer"; }
  ];
}
