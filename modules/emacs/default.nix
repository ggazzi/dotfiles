{ pkgs, config, lib, ... }:

{
  config =
    let
      inherit (config) xdg;
      doomDir = "${xdg.configHome}/doom-emacs";
      doomLocalDir = "${xdg.dataHome}/doom-emacs";
    in
    {
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
        DOOMDIR = doomDir;
        DOOMLOCALDIR = doomLocalDir;
      };

      programs.git = {
        # Have git always ignore some emacs-related files
        ignores = [
          ".projectile"
          ".dir-locals.el"
          "*.elc"
        ];

        # Improve git diffs for org files
        attributes = [ "*.org diff=org" ];
        extraConfig = {
          "diff \"org\"" = {
            xfuncname = "^(\\*+ +.*)$";
          };
        };
      };

      xdg.configFile = {

        # Install a link to the config file, then tangle it
        # If doom is installed, update it accordingly
        "doom-emacs/config.org" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.ggazzi.configDir}/modules/emacs/config.org";

          onChange = "${pkgs.writeShellScript "emacs-config-change" ''
            export DOOMDIR="${doomDir}"
            export DOOMLOCALDIR="${doomLocalDir}"

            emacs --batch --eval "(progn (require 'org) (setq org-confirm-babel-evaluate nil) (org-babel-tangle-file \"${doomDir}/config.org\"))"
            if which doom
            then
              doom sync
            fi
          ''}";
        };

        "doom-emacs/snippets" = {
          source = ./snippets;
          recursive = true;
        };

      };
    };
}
