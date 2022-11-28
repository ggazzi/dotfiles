{ pkgs, config, lib, ... }:

{
  config = {
    home.packages = with pkgs; [ rnix-lsp ];
  };
}