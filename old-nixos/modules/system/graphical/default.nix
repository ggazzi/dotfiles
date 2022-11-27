{ pkgs, config, lib, ... }:
with lib;

# Configuration for machines with a desktop environment.
# These are generally desktop or laptop machines.

let cfg = config.ggazzi.graphical;
in {
  imports = [
    ./gnome.nix
    ./nvidia-optimus.nix
  ];

  options.ggazzi.graphical = {
    enable = mkOption {
      description = "Enable a graphical environment";
      type = types.bool;
      default = false;
    };

    games = {
      steam = mkOption {
        description = "Install Steam";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (cfg.enable) {
    programs.steam.enable = cfg.games.steam;

    # Use X Keyboard config in ttys as well
    console.useXkbConfig = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable GDM as display manager.
    services.xserver.displayManager.gdm.enable = true;

    # Configure keymap in X11
    services.xserver.layout = "us";
    services.xserver.xkbVariant = "intl";
    # services.xserver.xkbOptions = "eurosign:e";

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Make sure that Fn keys are not used as media keys by default\
    boot.extraModprobeConfig = ''
      # Function/media keys:
      #   0: Function keys only, regardless of fn
      #   1: Media keys by default, function keys when fn is pressed
      #   2: Function keys by default, media keys when fn is pressed
      options hid_apple fnmode=2
    '';

    # Enable touchpad support.
    services.xserver.libinput.enable = true;
  };
}
