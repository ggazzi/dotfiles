{ pkgs, config, lib, ... }:

let
  inherit (config) xdg home;
in
{
  home.packages = with pkgs; [
    gh # Client for working with GitHub projects
    dev-cli-utils
  ];

  home.sessionVariables = {
    # Directory into which all GitHub repositories are cloned
    WORKSPACE = "${home.homeDirectory}/workspace";
  };

  programs.zsh.initExtraBeforeCompInit =
    ''source "${home.homeDirectory}/.nix-profile/opt/dev-cli-utils/completions.zsh"'';

  programs.tmux = {
    enable = true;
  };
}
