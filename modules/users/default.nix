{ pkgs, config, lib, ... }:

{
  imports = [
    ./applications.nix
    ./bash
    ./games.nix
    ./git.nix
    ./gnome.nix
  ];

  config = {
    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;

    # Use english as the main language
    home.language.base = "en_GB.UTF-8";

    # Basic configuration for the shell
    home = {
      sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

      shellAliases = {
        open = "xdg-open";
      };
    };
  };
}