{ pkgs, config, lib, ... }:

let
  inherit (config) xdg;
in
{
  programs.zsh.enable = true;
  home.packages = with pkgs; [
    starship direnv
  ];

  home.sessionVariables = {
    ZSH_HOME = "${xdg.configHome}/zsh";
  };

  home.file = {
    ".zprofile".text = "source ~/.nix-profile/etc/profile.d/hm-session-vars.sh\nsource $HOME/.zshrc\n";
    ".zshrc".text = ''source "$ZSH_HOME/rc.zsh"'';
  };

  xdg.configFile = {
    "starship.toml".source = ./starship.toml;
    "zsh" = {
      source = ./config;
      recursive = true;
    };
  };
}
