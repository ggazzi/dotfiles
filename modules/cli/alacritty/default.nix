{ config, lib, pkgs, ... }:

{
  config = {
    programs.alacritty = {
      enable = true;

      settings = {

        window.padding = { x = 5; y = 5; };
        mouse.hide_when_typing = true;
        colors = import ./colour-theme-nord.nix;

        font = {
          size = 13.0;
          normal = {
            family = "FiraCode Nerd Font";
            style = "Regular";
          };
        };
      };

    };
  };
}
