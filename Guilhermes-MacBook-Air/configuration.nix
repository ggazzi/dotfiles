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

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.configureBuildUsers = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
