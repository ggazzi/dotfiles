{ pkgs, config, lib, ... }:

{
  config = {
    programs.helix = {
      enable = true;
      defaultEditor = true;

      settings = {
        theme = "catppuccin_mocha";

        editor = {
          line-number = "relative";
          gutters = ["diff" "diagnostics" "line-numbers" "spacer"];
          soft-wrap.enable = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          statusline = {
            left = ["diagnostics" "spinner" "file-name"];
            right = ["selections" "position" "workspace-diagnostics"];
          };
        };        
      };
    };
  };
}
