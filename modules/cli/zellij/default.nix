{ pkgs, config, lib, ... }:

{
  programs.zellij.enable = true;

  xdg.configFile = {
    "zellij/config.kdl".source = ./config.kdl;
    "zellij/themes" = { source = ./themes; recursive = true; };
    "zellij/layouts" = { source = ./layouts; recursive = true; };
  };

}
