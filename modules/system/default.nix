{ pkgs, config, lib, ... }:

{
  imports = [
    ./desktop
    ./printers.nix
  ];


  config = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

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

    # Some very basic packages that are needed pretty much everywhere
    environment.systemPackages = with pkgs; [
      vim git wget
    ];
  };

}
