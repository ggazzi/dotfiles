{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.ggazzi.applications;
  systemCfg = config.machineData.systemConfig;
in {

  imports = [
    ./emacs
    ./graphical
  ];

  options.ggazzi.applications = {
    enable = mkOption {
      description = "Enable a set of common applications";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {

    home.packages = with pkgs; [
      # CLI tools
      (python3.withPackages (p : with p; [virtualenv virtualenvwrapper]))
    ];

  };

}
