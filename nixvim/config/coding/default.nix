{ pkgs, ... }:

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
    plugins = {
      which-key.settings.spec = [
        { __unkeyed-1 = "<leader>c"; group = "Code"; }
      ];

      # Detect tabstop and shiftwidth automatically
      sleuth.enable = true;

      nvim-surround.enable = true;

      trim = {
        enable = true;
        settings = {
          highlight = true;
          trim_on_write = true;
          trim_trailing = true;
          trim_last_line = true;
        };
      };
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "targets-vim";
        src = pkgs.fetchFromGitHub {
          owner = "wellle";
          repo = "targets.vim";
          rev = "master";
          sha256 = "sha256-ThfL4J/r8Mr9WemSUwIea8gsolSX9gabJ6T0XYgAaE4=";
        };
      })
    ];
  };
}
