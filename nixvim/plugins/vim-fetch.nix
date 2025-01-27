{ pkgs, lib, config, ... }:

let cfg = config.plugins.vim-fetch;
in {
  options.plugins.vim-fetch = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable vim-fetch plugin";
    };
  };

  config = lib.mkIf cfg.enable {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-fetch";
        src = pkgs.fetchFromGitHub {
          owner = "wsdjeg";
          repo = "vim-fetch";
          rev = "master";
          sha256 = "sha256-uf7N2DI8comlOdRrimuwA7+cnKeL2RQSz0TFvTiUVmQ=";
        };
      })
    ];
  };
}
