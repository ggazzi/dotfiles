{ pkgs, lib, config, ... }:

let cfg = config.plugins.treesj;
in {
  options.plugins.treesj = with lib; {
    enable = mkOption {
      default = false;
      description = "Enable treesj plugin";
      type = types.bool;
    };
    useDefaultKeymaps = mkOption {
      default = true;
      description = "Use default keymaps";
      type = types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "treesj";
        src = pkgs.fetchFromGitHub {
          owner = "Wansmer";
          repo = "treesj";
          rev = "main";
          sha256 = "sha256-uf7N2DI8comlOdRrimuwA7+cnKeL2RQSz0TFvTiUVmQ=";
        };
      })
    ];

    extraConfigLua = ''
      require('treesj').setup { use_default_keymaps = ${if cfg.useDefaultKeymaps then "true" else "false"} }
    '';
  };
}
