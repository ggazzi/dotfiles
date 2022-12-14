{ pkgs, config, lib, ... }:

{
  config = {
    # I am not managing doom emacs with nix.

    # I only install some dependencies for doom
    # Emacs is installed with homebrew, so I have
    # access to the application graphically
    home.packages = with pkgs; [ ripgrep fd ];

    # Make sure that doom is on the path
    home.sessionPath = [ "$HOME/.emacs.d/bin/" ];

    # Add a shortcut for emacs
    home.shellAliases.e = "emacs -nw";

    home.sessionVariables = {
      # Set the directories where the doom configuration should go
      DOOMDIR = "${config.xdg.configHome}/doom-emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom-emacs";

      # Use as default command-line editor
      EDITOR = "emacs -nw";
      VISUAL = "emacs -nw";
    };

  };
}
