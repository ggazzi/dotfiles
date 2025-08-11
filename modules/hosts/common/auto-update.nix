# Auto-update module for dotfiles configuration
# Works on both Darwin (launchd) and NixOS (systemd)
{
  lib,
  pkgs,
  config,
  configPath,
  isDarwin,
  ...
}:

with lib;

let
  cfg = config.services.dotfiles-auto-update;
in
{
  options.services.dotfiles-auto-update = {
    enable = mkEnableOption "automatic dotfiles updates";

    weekday = mkOption {
      type = types.ints.between 0 6;
      description = "Day of week (0=Sunday, 1=Monday, ..., 6=Saturday)";
    };

    hour = mkOption {
      type = types.ints.between 0 23;
      description = "Hour to run (24-hour format, 0-23)";
    };

    minute = mkOption {
      type = types.ints.between 0 59;
      description = "Minute to run (0-59)";
    };
  };

  config = mkIf cfg.enable (
    let
      # Weekday names for systemd calendar format
      weekdayNames = [
        "Sun"
        "Mon"
        "Tue"
        "Wed"
        "Thu"
        "Fri"
        "Sat"
      ];

      # Common configuration for both platforms
      commonConfig = {
        # Ensure just is available system-wide
        environment.systemPackages = [ pkgs.just ];

        # Platform detection validation
        assertions = [
          {
            assertion = isDarwin == true || isDarwin == false;
            message = "isDarwin must be defined as a boolean value";
          }
        ];
      };

      # Darwin-specific configuration
      darwinConfig = {
        launchd.daemons.dotfiles-auto-update = {
          script = "${pkgs.just}/bin/just update apply";
          serviceConfig = {
            StartCalendarInterval = [
              {
                Weekday = cfg.weekday;
                Hour = cfg.hour;
                Minute = cfg.minute;
              }
            ];
            StandardOutPath = "/var/log/dotfiles-update.log";
            StandardErrorPath = "/var/log/dotfiles-update-error.log";
            RunAtLoad = false;
            StartOnMount = true;
            WorkingDirectory = configPath;
          };
        };
      };

      # NixOS-specific configuration
      nixosConfig = {
        systemd.services.dotfiles-auto-update = {
          description = "Auto-update dotfiles configuration";
          script = "${pkgs.just}/bin/just update apply";
          serviceConfig = {
            Type = "oneshot";
            WorkingDirectory = configPath;
          };
        };

        systemd.timers.dotfiles-auto-update = {
          description = "Timer for dotfiles auto-update";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "${builtins.elemAt weekdayNames cfg.weekday} *-*-* ${toString cfg.hour}:${toString cfg.minute}:00";
            Persistent = true;
          };
        };
      };

      # Platform-specific configuration
      platformConfig = if isDarwin then darwinConfig else nixosConfig;
    in
    # Merge common config with platform-specific config
    lib.recursiveUpdate commonConfig platformConfig
  );
}
