{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.nixvim.plugins.vim-fetch;
in
{
  options.programs.nixvim.plugins.vim-fetch = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable vim-fetch plugin";
    };
  };

  config.programs.nixvim.extraPlugins =
    if cfg.enable then
      [
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-fetch";
          src = pkgs.fetchFromGitHub {
            owner = "wsdjeg";
            repo = "vim-fetch";
            rev = "master";
            sha256 = "sha256-uf7N2DI8comlOdRrimuwA7+cnKeL2RQSz0TFvTiUVmQ=";
          };
        })
      ]
    else
      [ ];
}
