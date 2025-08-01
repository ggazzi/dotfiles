{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.nixvim.plugins.targets-vim;
in
{
  options.programs.nixvim.plugins.targets-vim = with lib; {
    enable = mkOption {
      default = false;
      description = "Enable targets-vim plugin";
      type = types.bool;
    };
  };

  config.programs.nixvim.extraPlugins =
    if cfg.enable then
      [
        # Add targets like "inside brackets" and "around brackets"
        (pkgs.vimUtils.buildVimPlugin {
          name = "targets-vim";
          src = pkgs.fetchFromGitHub {
            owner = "wellle";
            repo = "targets.vim";
            rev = "master";
            sha256 = "sha256-ThfL4J/r8Mr9WemSUwIea8gsolSX9gabJ6T0XYgAaE4=";
          };
        })
      ]
    else
      [ ];
}
