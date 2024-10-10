{
  imports = [
    ./completion.nix
    ./copilot.nix
    ./langs
    ./lsp.nix
  ];

  config = {
    plugins.which-key.settings.spec = [
      { __unkeyed-1 = "<leader>c"; group = "Code"; }
    ];

    # Detect tabstop and shiftwidth automatically
    plugins.sleuth.enable = true;
  };
}
