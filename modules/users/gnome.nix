{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.gnome;
  systemCfg = config.machineData.systemConfig;
in {
  config = mkIf (systemCfg.desktop.enable) {
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      arc-theme arc-icon-theme
    ];
  };
}
