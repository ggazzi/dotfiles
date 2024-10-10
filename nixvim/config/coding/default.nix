{
  imports = [
    ./comments.nix
    ./completion.nix
    ./copilot.nix
    ./diagnostics.nix
    ./folding.nix
    ./langs
    ./lsp.nix
    ./treesitter.nix
  ];

  config = {
    plugins.which-key.settings.spec = [
      { __unkeyed-1 = "<leader>c"; group = "Code"; }
    ];

    # Detect tabstop and shiftwidth automatically
    plugins.sleuth.enable = true;
  };
}
