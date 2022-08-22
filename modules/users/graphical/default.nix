{ pkgs, config, lib, ... }:
with lib;

{
  imports = [
    ./gnome.nix
    ./games
  ];
}
