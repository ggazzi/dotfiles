{ config, lib, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      nodePackages.bash-language-server
      shellcheck
    ];
  };
}
