{
  imports = [
    ./brackets.nix
    ./comments.nix
    ./completion.nix
    ./copilot.nix
    ./diagnostics.nix
    ./folding.nix
    ./langs
    ./lsp.nix
    ./treesitter.nix
    ./whitespace.nix
  ];

  programs.nixvim = {
    plugins = {
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>c";
          group = "Code";
          mode = [
            "n"
            "v"
          ];
        }
      ];
    };
  };
}
