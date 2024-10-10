{
  plugins.neo-tree = {
    enable = true;
  };

  keymaps = [
    { key = "<leader>wt"; action = ":Neotree<CR>"; options.desc = "Open filesystem tree as a sidebar"; }
  ];
}
