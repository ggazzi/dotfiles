{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.games;
  systemCfg = config.machineData.systemConfig;
in {
  options.ggazzi.games = {
    minecraft = {
      enable = mkOption {
        description = "Install the PolyMC minecraft launcher";
        type = types.bool;
        default = false;
      };
    };
  };

  config = {
    home.packages = with pkgs;
      (if cfg.minecraft.enable then [polymc] else []) ++
      (if systemCfg.desktop.games.steam then [steam] else []);
  };
}
