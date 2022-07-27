{ pkgs, config, lib, ... }:
with lib;

# Configuration for machines with a desktop environment.
# These are generally desktop or laptop machines.

let cfg = config.ggazzi.desktop;
in {
  imports = [
    ./nvidia-optimus.nix
  ];

  options.ggazzi.desktop = {
    enable = mkOption {
      description = "Enable a desktop environment";
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

    # Time zone where my machines generally are
    time.timeZone = "Europe/Berlin";

    # Use X Keyboard config in ttys as well
    console.useXkbConfig = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

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

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Set some default MIME associations
    xdg.mime = {
      enable = true;
      addedAssociations = {
        "application/pdf" = "evince.desktop";

        "application/x-yaml" = "org.gnome.TextEditor.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
      };
      defaultApplications = {
        "application/pdf" = "evince.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  };
}
