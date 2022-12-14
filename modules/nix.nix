{ pkgs, config, lib, ... }:

{
  config = {
    home.packages = with pkgs; [
      # Install an LSP to help edit my nix files
      rnix-lsp
    ];
  };
}
