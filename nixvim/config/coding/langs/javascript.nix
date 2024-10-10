{
  plugins = {
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
  };
}
