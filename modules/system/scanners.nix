{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.ggazzi.scanners;
in {
  options.ggazzi.scanners = {
    enable = mkOption {
      description = "Install CUPS for printing";
      type = types.bool;
      default = false;
    };

    backends = mkOption {
      description = ''
        Additional backends for SANE.
        For more information, see the option <literal>hardware.sane.extraBackends</literal>.
      '';
      type = types.listOf types.path;
      default = [];
    };
  };

  config = mkIf (cfg.enable) {
    hardware.sane.enable = true;
    hardware.sane.extraBackends = cfg.backends;
  };
}
