{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        completion.autocomplete = false;
      };
    };

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
