{ pkgs, config, lib, ... }:
with lib;

let   
  cfg = config.ggazzi.printers;
in {
  options.ggazzi.printers = {
    enable = mkOption {
      description = "Install CUPS for printing";
      type = types.bool;
      default = false;
    };

    drivers = mkOption {
      description = ''
        CUPS drivers to use. 
        For more information, see the option <literal>services.printing.drivers</literal>.

        Must be a function taking the <literal>pkgs</literal> set and returning the list of drivers.
        '';
      type = types.listOf types.path;
      default = [];
    };
  };

  config = mkIf (cfg.enable) {
    services.printing.enable = true;
    services.printing.drivers = cfg.drivers;
  };
}