{ pkgs, config, lib, ... }:

with lib; let
  cfg = config.ggazzi.helix;

in
{

  options.ggazzi.helix = {
    defaultEditor = mkOption
      {
        description = "Set helix as the default editor in the CLI";
        type = types.bool;
        default = false;
      };
  };


  config = {
    programs.helix = {
      enable = true;
      defaultEditor = cfg.defaultEditor;

      settings = {
        theme = "catppuccin_mocha";

        editor = {
          line-number = "relative";
          gutters = [ "diff" "diagnostics" "line-numbers" "spacer" ];
          soft-wrap.enable = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          statusline = {
            left = [ "diagnostics" "spinner" "file-name" ];
            right = [ "selections" "position" "workspace-diagnostics" ];
          };
        };
      };
    };
  };
}
