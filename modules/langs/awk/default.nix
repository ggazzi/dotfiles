{ config, lib, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      gawk
    ];
  };
}
