{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.applications.vivaldi;
  systemCfg = config.machineData.systemConfig;
in {

  options.ggazzi.applications.vivaldi = {
    enable = mkOption {
      description = "Enable the Vivaldi browser";
      type = types.bool;
      default = false;
    };

    default = mkOption {
      description = "Make Vivaldi the default browser";
      type = types.bool;
      default = false;
    };
  };

  config = let
    src-dir = "${config.ggazzi.configDir}/modules/users/applications/graphical/vscode";
  in mkIf (cfg.enable && systemCfg.desktop.enable) {

    home.packages = with pkgs; [vivaldi vivaldi-ffmpeg-codecs];

    xdg.mimeApps = {
      defaultApplications = mkIf cfg.default {
        "application/xhtml+xml" = "vivaldi-stable.desktop";
        "text/html" = "vivaldi-stable.desktop";
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
      };
    };

  };

}
