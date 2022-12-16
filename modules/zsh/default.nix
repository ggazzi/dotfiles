{ pkgs, config, lib, ... }:

let
  inherit (config) xdg;
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    # Add all files from ./config to the end of .zrc
    initExtra =
      with builtins;
      let
        cfgFiles = readDir ./config;
        readCfg = name: _: readFile (./config + "/${name}");
        cfgContents = (attrValues (mapAttrs readCfg cfgFiles));
      in
      concatStringsSep "\n" cfgContents;
  };

  # Use direnv to manage environment variables on a per-directory basis
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # Use starship for a pretty and helpful shell prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {

      add_newline = true;

      character = {
        success_symbol = "[✓](bold green) [»](cyan)";
        error_symbol = "[✗](bold red) [»](cyan)";
      };

      directory.substitutions = {
        "Documents" = " ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
        "workspace" = "";
      };

    };
  };
}
