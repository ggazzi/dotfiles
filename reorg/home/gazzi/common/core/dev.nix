{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.ggazzi.dev;
  inherit (config) home;
in
{
  options.ggazzi.dev = {
    workspace = lib.mkOption {
      default = "${home.homeDirectory}/workspace";
      type = lib.types.str;
      description = "Directory into which GitHub repositories are cloned";
    };
  };

  config = {
    home.packages = with pkgs; [
      gh # Client for working with GitHub projects
      fzf
      dev-utils

      jq # Great utility for handling JSON files
    ];

    home.sessionVariables = {
      # Directory into which all GitHub repositories are cloned
      WORKSPACE = cfg.workspace;
    };

    programs.zsh.initContent = lib.mkOrder 550 ''source "${home.homeDirectory}/.nix-profile/opt/dev-utils/completions.zsh"'';
  };
}
