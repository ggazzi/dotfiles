{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        completion.autocomplete = false;
      };

      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
      ];
    };

    cmp-nvim-lsp.enable = true;

    lspkind.enable = true;
  };

  keymaps = [
    {
      mode = "i";
      key = "<C-Space>";
      action = "cmp#complete()";
      options = { noremap = true; silent = true; };
    }
  ];
}
