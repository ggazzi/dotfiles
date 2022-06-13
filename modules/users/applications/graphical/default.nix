{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.applications;
  systemCfg = config.machineData.systemConfig;
in {

  config = mkIf (cfg.enable && systemCfg.desktop.enable) {
    home.packages = with pkgs; [
      # Password manager
      keepassxc

      # Cloud Storage
      seafile-client      

      # Browser
      vivaldi vivaldi-ffmpeg-codecs

      # Communication tools
      tdesktop discord

      # Fonts
      fira fira-mono fira-code fira-code-symbols
    ];

    # Visual Studio Code as a text editor
    programs.vscode.enable = true;

    xdg.mimeApps = {
      defaultApplications = {
        "application/pdf" = "evince.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";

        "application/x-shellscript" = "code.desktop";
        "application/x-perl" = "code.desktop";
        "application/json" = "code.desktop";
        "text/x-readme" = "code.desktop";
        "text/plain" = "code.desktop";
        "text/markdown" = "code.desktop";
        "text/x-csrc" = "code.desktop";
        "text/x-chdr" = "code.desktop";
        "text/x-python" = "code.desktop";

        "application/xhtml+xml" = "vivaldi-stable.desktop";
        "text/html" = "vivaldi-stable.desktop";
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
      };
    };

    # Make discord work even when the latest version isn't available on nix
    xdg.configFile."discord/settings.json".text = ''
      { "SKIP_HOST_UPDATE": true }
    '';
    
    fonts.fontconfig.enable = systemCfg.desktop.enable;
  };

}
