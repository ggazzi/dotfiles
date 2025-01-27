{
  plugins = {
    lsp.servers.rust_analyzer = {
      enable = true;

      # Don't install the toolchain, use from the environment.
      #
      # Different projects may have different toolchains configured,
      # this nixvim config should be usable for all of them.
      installCargo = false;
      installRustc = false;
    };
  };
}
