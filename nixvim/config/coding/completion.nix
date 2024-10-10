{
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      completion.autocomplete = false;
    };
  };

  plugins.lspkind.enable = true;

  keymaps = [
    {
      mode = "i";
      key = "<C-Space>";
      action = "cmp#complete()";
      options = { noremap = true; silent = true; };
    }
  ];
}
