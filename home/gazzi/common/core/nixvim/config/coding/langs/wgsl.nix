{
  programs.nixvim.plugins = {
    lsp.servers.wgsl_analyzer = {
      enable = true;
    };
  };
}
