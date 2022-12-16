{ config, pkgs, lib, ... }:

{

  options.ggazzi = with lib; {
    configDir = mkOption {
      description = "Path to this configuration flake.";
      type = types.str;
      default = "${config.home.homeDirectory}/workspace/ggazzi/dotfiles";
    };
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "gazzi";
    home.homeDirectory = "/Users/gazzi";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.packages = with pkgs; [ dev-cli-utils ];
  };
}
