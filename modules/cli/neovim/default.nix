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
    home.packages = with pkgs; [
      nixvim
      ripgrep
    ];

    home.sessionVariables = lib.mkIf cfg.defaultEditor {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

}
