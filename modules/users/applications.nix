{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.applications;
  systemCfg = config.machineData.systemConfig;

  graphical_apps = with pkgs; [
    # Password manager
    keepassxc

    # Cloud Storage
    seafile-client      

    # Browser
    vivaldi vivaldi-ffmpeg-codecs

    # Communication tools
    tdesktop discord

    # Text editor
    vscode

    # Fonts
    fira fira-mono fira-code fira-code-symbols
  ];

  cli_apps = with pkgs; [
    # CLI tools
    (python3.withPackages (p : with p; [virtualenv virtualenvwrapper]))

  ];
in {
  options.ggazzi.applications = {
    enable = mkOption {
      description = "Enable a set of common applications";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = cli_apps ++ (if systemCfg.desktop.enable then graphical_apps else []) ;

    xdg.configFile."discord/settings.json".text = ''
      { "SKIP_HOST_UPDATE": true }
    '';
    
    fonts.fontconfig.enable = systemCfg.desktop.enable;
  };

}