{
  programs.nixvim.plugins = {
    lsp.servers.ts_ls = {
      enable = true;
      filetypes = [
        "javascript"
        "javascriptreact"
        "typescript"
        "typescriptreact"
      ];
    };
    lsp.servers.eslint.enable = true;

    none-ls = {
      enable = true;
      sources.formatting.prettier = {
        enable = true;
        disableTsServerFormatter = true;
      };
    };
  };
}
