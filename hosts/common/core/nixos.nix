# Core functionality for every nixos host.
{ lib, ... }:

{
  # Database for aiding terminal-based programs
  environment.enableAllTerminfo = true;

  #
  # ========== Localization ==========
  #

  time.timeZone = lib.mkDefault "Europe/Berlin";

  console.keyMap = "us-acentos";

  i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";
  i18n.extraLocaleSettings = builtins.mapAttrs (_name: value: lib.mkDefault value) {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Time synchronization for all NixOS systems
  services.timesyncd.enable = true;

  # PolicyKit for privilege escalation - used by NetworkManager, systemd, and many other services
  security.polkit.enable = true;

}
