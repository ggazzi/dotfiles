{ pkgs, config, lib, ... }:

{
  config = {
    home.packages = with pkgs; [ helix ];

    xdg.configFile = {
      "helix/config.toml".source = ./config.toml;
    };

    home.sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };
}
