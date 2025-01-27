{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    gitAndTools.gitFull
    home-manager
  ];

  users.users.gazzi.home = "/Users/gazzi";

  # Auto-upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  nix.settings = rec {
    experimental-features = "nix-command flakes";

    substituters = trusted-substituters;
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.configureBuildUsers = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  ids.gids.nixbld = 350;
}
