{
  hostSpec,
  lib,
  pkgs,
  ...
}:
let
  platform = if pkgs.stdenv.isDarwin then "darwin" else "nixos";
in
{
  imports = [
    ./${platform}.nix
    ./git
    ./zsh
  ];

  home = {
    username = lib.mkDefault hostSpec.username;
    homeDirectory = lib.mkDefault hostSpec.home;
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      SHELL = "zsh";
    };
    preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;
}
