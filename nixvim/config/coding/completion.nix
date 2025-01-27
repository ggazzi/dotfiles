{
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;

    settings = {
      # Only trigger completion manually
      completion.autocomplete = false;

      mapping = {
        "<C-k>" = "cmp.mapping.scroll_docs(-4)";
        "<C-j>" = "cmp.mapping.scroll_docs(4)";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if hasOnlyWhitespaceBefore() then
              fallback()
            else
              if not cmp.visible() then
                cmp.complete()
              end
              cmp.select_next_item()
            end
          end, { 'i', 's' })
        '';
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if hasOnlyWhitespaceBefore() then
              fallback()
            else
              if not cmp.visible() then
                cmp.complete()
              else
                cmp.select_prev_item()
              end
            end
          end, { 'i', 's' })
        '';
      };
    };
  };

  extraConfigLuaPre = ''
    local hasOnlyWhitespaceBefore = function()
      local col = vim.fn.col('.') - 1
      return col < 1 or vim.fn.getline('.'):sub(1, col):match('^%s*$')
    end
  '';
}
