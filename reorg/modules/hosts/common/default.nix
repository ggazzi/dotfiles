# Add your reusable common modules to this directory, on their own file (https://wiki.nixos.org/wiki/NixOS_modules).
# These are modules not specific to either nixos or darwin, (but _not for home-manager_) that you would share with others, not your personal configurations.
{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}
