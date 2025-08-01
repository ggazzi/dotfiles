# Add your reusable common modules to this directory, on their own file (https://wiki.nixos.org/wiki/NixOS_modules).
# These are modules specific to darwin that you would share with others, not your personal configurations.
{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}
