#############################################################
#
#  Gui's Wagon - Laptop
#  Mac OS running on a MacBook Air (13-inch, M3, 2024)
#
#############################################################

{
  lib,
  ...
}:

{
  imports = map lib.custom.relativeToRoot [
    #
    # ========== Required Configs ==========
    #
    "hosts/common/core"
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "Guis-wagon";
    username = "gazzi";
  };

  nix.settings = rec {
    # TODO: either remove or move away from this file (where?)
    substituters = trusted-substituters;
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  ids.gids.nixbld = 350;
}
