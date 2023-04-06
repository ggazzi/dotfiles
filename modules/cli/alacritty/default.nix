{ config, lib, pkgs, ... }:

{
  config = {
    xdg.configFile."alacritty/alacritty.yml".source = ./config.yaml;
  };
}
