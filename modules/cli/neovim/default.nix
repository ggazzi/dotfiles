{ pkgs, config, lib, ... }:

with lib; let
  cfg = config.ggazzi.neovim;
in
{

  options.ggazzi.neovim = {
    defaultEditor = mkOption
      {
        description = "Set neovim as the default editor in the CLI";
        type = types.bool;
        default = false;
      };
  };

  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      extraLuaConfig = readFile ./init.lua;
    };

    home.packages = with pkgs; [
      # Dependencies of mason.nvim (package manager for LSPs, linters, etc)
      git
      curl
      unzip
      gnutar
      gzip
      nodejs

      # Dependencies of telescope.nvim
      ripgrep
    ];

    # Include all lua config files
    xdg.configFile."nvim/lua/" = {
      source = ./lua;
      recursive = true;
    };
  };

}
