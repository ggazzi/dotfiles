{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
    };

    keymaps = [
      {
        key = "<leader>wt";
        action = ":Neotree<CR>";
        options.desc = "Open filesystem tree as a sidebar";
      }
    ];

    # Don't show a statusline for the filetree buffer.
    plugins.lualine.settings.options.disabled_filetypes.statusline = [ "neo-tree" ];
  };
}
