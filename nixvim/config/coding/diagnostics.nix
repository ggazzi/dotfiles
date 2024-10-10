{
  plugins.trouble.enable = true;

  keymaps = [
    {
      key = "<leader>wd";
      action = "Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Diagnostics for buffer";
    }
    {
      key = "<leader>wD";
      action = "Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics for workspace";
    }
  ];
}
