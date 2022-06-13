{ pkgs, config, lib, ... }:

with lib; let
  cfg = config.ggazzi.emacs;
  systemCfg = config.machineData.systemConfig;

in {
  options.ggazzi.emacs = {
    enable = mkOption {
      description = "Enable and install Emacs";
      type = types.bool;
      default = false;
    };

    native-compilation = mkOption {
      description = "Install a variant of Emacs that compiles Elisp to native code";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    # I am not managing doom emacs with nix.
    # Instead, I install emacs along with any external dependencies and manage
    # the configuration. Doom itself must be installed manually.
   
    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-emacs";
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom-emacs";
      EDITOR="emacs -nw";
      VISUAL="emacs -nw";
    };

    # Install and tangle the config file, then update doom accordingly (if installed)
    xdg.configFile."doom-emacs/config.org" = {
      source = config.lib.file.mkOutOfStoreSymlink ./config.org;
      onChange = "${pkgs.writeShellScript "emacs-config-change" ''
        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"

        emacs --batch --eval "(progn (require 'org) (setq org-confirm-babel-evaluate nil) (org-babel-tangle-file \"${config.xdg.configHome}/doom-emacs/config.org\"))"
        if which doom 
        then 
          doom sync
        fi
      ''}";
    };

    # Make sure Emacs is used to open org files
    xdg.mimeApps = {
      defaultApplications = {
        "text/org" = "emacs.desktop";
      };
      associations.added = {
        "text/org" = "emacs.desktop";
      };
    };

    # Provide a helper script to install doom emacs to the appropriate location
    home.sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin" ];
    home.file = {
      ".local/bin/doom-install" = {
        executable = true;
        text = ''
          #!/bin/sh
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"

          if ! (~/.emacs.d/bin/doom >/dev/null 2>/dev/null)
          then
            if [ -e ~/.emacs.d ]
            then
              echo "Doom isn't installed, but `.emacs.d` already exists."
              echo "Move it away and try again."
              exit 1
            else
              echo "Cloning the doom-emacs git repository..."
              git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d || exit 1
              echo
            fi
          fi

          echo "Installing doom..."
          ~/.emacs.d/doom -y install
        '';
      };
    };

    home.packages = with pkgs; [ 
      (
        if systemCfg.desktop.enable then
          if cfg.native-compilation then
            emacs28NativeComp
          else
            emacs
        else 
          emacs-nox
      )

      # Doom Emacs dependencies
      (ripgrep.override { withPCRE2 = true; })
      fd

      # Configuration dependencies
      editorconfig-core-c
      graphviz
      noto-fonts
      plantuml
      shellcheck # shell script linting
      sqlite # org-roam
    ];
  };
}
