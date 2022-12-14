{ pkgs, config, lib, ... }:

{
  config = {
    # I am not managing doom emacs with nix.
    # Instead, I install emacs along with any external dependencies and manage
    # the configuration. Doom itself must be installed manually.

    home.packages = with pkgs; [ ripgrep fd ];

    home.sessionPath = [ "$HOME/.emacs.d/bin/" ];

    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom-emacs";
      EDITOR = "emacs -nw";
      VISUAL = "emacs -nw";
    };
  };
}
