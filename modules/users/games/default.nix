{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.games;
  systemCfg = config.machineData.systemConfig;
in {
  options.ggazzi.games = {
    minecraft = {
      enable = mkOption {
        description = "Install the minecraft launcher";
        type = types.bool;
        default = false;
      };
    };
  };

  config = {
    home.packages = with pkgs; 
      (if systemCfg.desktop.enable && cfg.minecraft.enable then [minecraft] else []) ++ 
      (if systemCfg ? desktop.games.steam && systemCfg.desktop.games.steam then [steam] else []);
  };
}
