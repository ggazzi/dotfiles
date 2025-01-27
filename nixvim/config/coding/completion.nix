{
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;

    settings = {
      # Only trigger completion manually
      completion.autocomplete = false;

      mapping = {
        "<C-i>" = "cmp.mapping(cmp.mapping.complete(), { 'i' })";
        "<C-k>" = "cmp.mapping.scroll_docs(-4)";
        "<C-j>" = "cmp.mapping.scroll_docs(4)";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "S-Tab" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
      };
    };
  };
}
