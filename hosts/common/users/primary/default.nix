# User config applicable to both nixos and darwin
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  hostSpec = config.hostSpec;
in
{
  users.users.${hostSpec.username} = {
    name = hostSpec.username;
    shell = pkgs.zsh; # default shell
  };

  # No matter what environment we are in we want these tools
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    rsync
  ];
}
# Import the user's personal/home configurations, unless the environment is minimal
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };

    users.${hostSpec.username}.imports = lib.flatten (
      lib.optional true [
        (
          { config, ... }:
          import (lib.custom.relativeToRoot "home/${hostSpec.username}/${hostSpec.hostName}.nix") {
            inherit
              pkgs
              inputs
              config
              lib
              hostSpec
              ;
          }
        )
      ]
    );
  };
}
