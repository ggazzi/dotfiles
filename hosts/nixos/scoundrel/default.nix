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
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/printing.nix"
      "hosts/common/optional/bluetooth.nix"

    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "scoundrel";
    username = "gazzi";
    networking = {
      ports.tcp.ssh = 22;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  services = {
    logind = {
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
    };
  };

  virtualisation.docker.enable = true;

  networking.firewall.allowedTCPPorts = [
    53 # Necessary for DHCP server with pihole

    # HTTP(S) ports
    80
    443

    1883 # MQTT
    8123 # Home Assistant Web UI

    # Home Assistant (necessary for integrations/discovery)
    1400
    9999
  ];
  networking.firewall.allowedUDPPorts = [
    1900 # uPNP
    5353 # mDNS
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
