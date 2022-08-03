{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.applications.vscode;
  systemCfg = config.machineData.systemConfig;
in {

  options.ggazzi.applications.vscode = {
    enable = mkOption {
      description = "Enable Visual Studio Code";
      type = types.bool;
      default = false;
    };

    default = mkOption {
      description = "Make VS Code the default text editor";
      type = types.bool;
      default = false;
    };
  };

  config = let
    src-dir = "${config.ggazzi.configDir}/modules/users/applications/graphical/vscode";
  in mkIf (cfg.enable && systemCfg.desktop.enable) {
    # Place the config files as links to this repository
    # (this way, configs can be changed by the editor)
    xdg.configFile."Code/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${src-dir}/settings.json";

    xdg.configFile."Code/User/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${src-dir}/keybindings.json";

    # Install VS Code and some extensions
    programs.vscode = {
      enable = true;

      extensions = with pkgs.vscode-extensions; with pkgs.vscode-utils; [
        # For dealing with nix
        arrterian.nix-env-selector
        jnoortheen.nix-ide

        # Common languages
        bungcip.better-toml
        mechatroner.rainbow-csv
        (buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "reflow-markdown";
            publisher = "marvhen";
            version = "2.1.0";
            sha256 = "TvxH06M/DwRRL3D+TKQKIb2AyyDmjFyj4JvvWHz+Kfk=";
          };
        })

        # Version control
        codezombiech.gitignore
        eamodio.gitlens
        mhutchie.git-graph

        # Other utilities
        editorconfig.editorconfig
        gruntfuggly.todo-tree
        stkb.rewrap
      ];
    };

    # Set as default text editor if necessary
    xdg.mimeApps.defaultApplications = mkIf cfg.default {
        "application/x-shellscript" = "code.desktop";
        "application/x-perl" = "code.desktop";
        "application/json" = "code.desktop";
        "text/x-readme" = "code.desktop";
        "text/x-csrc" = "code.desktop";
        "text/x-chdr" = "code.desktop";
        "text/x-python" = "code.desktop";
    };

  };

}
