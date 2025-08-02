#############################################################
#
#  Scoundrel - Server
#  NixOS running on an Intel N150 based mini PC
#
#############################################################

{
  lib,
  ...
}:

{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix

    (map lib.custom.relativeToRoot [

      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Host Specific Configs ==========
      #
      "hosts/common/optional/audio.nix"
      "hosts/common/optional/gnome.nix"
      "hosts/common/optional/services/printing.nix"

    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "scoundrel";
    username = "gazzi";
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
