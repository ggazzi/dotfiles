{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ggazzi";
  home.homeDirectory = "/home/ggazzi-nixos";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Guilherme Grochau Azzi";
    userEmail = "gui.g.azzi@gmail.com";

    delta.enable = true;

    aliases = {
      co = "checkout";
      st = "status -s -- .";

      unstage = "reset HEAD";

      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat";
      lg = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --graph";
      linfo = "log -p --decorate";

      diff-tree = "git diff";
      dt = "git diff";
      diff-index = "git diff --cached";
      di = "git diff --cached";
    };

    extraConfig = {
      branch.autosetuprebase = "always";
    };
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    keepassxc 
    tdesktop discord
    minecraft

    gitg
    shellcheck

    gnome.gnome-tweak-tool
    arc-theme arc-icon-theme
  ];
}
