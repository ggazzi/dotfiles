{ pkgs, config, lib, ... }:

{
  imports = [
    ./applications.nix
    ./games.nix
    ./git.nix
    ./gnome.nix
  ];

  config = {
    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;
  };
}