{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.ggazzi;
  nospace = str: filter (c: c == " ") (stringToCharacters str) == [];
  timezone = types.addCheck types.str nospace
    // { description = "string without spaces"; };

in
{
  imports = [
    ./graphical
    ./printers.nix
    ./scanners.nix
    ./sshd.nix
  ];

  options.ggazzi = {
    docker.enable = mkOption {
      description = "Enable the docker service";
      type = types.bool;
      default = false;
    };

    boot.efi.enable = mkOption {
      description = "Enable the systemd-boot EFI boot loader";
      type = types.bool;
      default = true;
    };

    networkmanager.enable = mkOption {
      description = "Enable usage of the NetworkManager";
      type = types.bool;
      default = true;
    };

    bluetooth.enable = mkOption {
      description = "Enable support for Bluetooth";
      type = types.bool;
      default = false;
    };

    time.timeZone = mkOption {
      default = "Europe/Berlin";
      type = timezone;
      description = "Time zone used when displaying dates and times.";
    };
  };

  config = {

    boot.loader = mkIf cfg.boot.efi.enable {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    nix = {
      # Allow usage of Flakes
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Save *a lot* of space
      autoOptimiseStore = true;
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      # keyMap = "us-acentos"; Needs to be set only for non-desktop environments
    };
    time = cfg.time;

    virtualisation.docker.enable = cfg.docker.enable;
    networking.networkmanager.enable = cfg.networkmanager.enable;

    hardware.bluetooth = cfg.bluetooth;

    # Some very basic packages that are needed pretty much everywhere
    environment.systemPackages = with pkgs; [
      vim git wget home-manager
    ];
  };

}
