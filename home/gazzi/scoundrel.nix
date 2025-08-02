{ pkgs, ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/zed
  ];

  home.packages = with pkgs; [
    bitwarden
  ];
}
