{ pkgs, config, lib, ... }:

let
  inherit (config) home;
in
{
  home.packages = with pkgs; [
    gh # Client for working with GitHub projects
    fzf
    dev-utils

    jq # Great utility for handling JSON files
  ];

  home.sessionVariables = {
    # Directory into which all GitHub repositories are cloned
    WORKSPACE = "${home.homeDirectory}/workspace";
  };

  programs.zsh.initExtraBeforeCompInit =
    ''source "${home.homeDirectory}/.nix-profile/opt/dev-utils/completions.zsh"'';
}
