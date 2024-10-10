{ pkgs, ... }:

{
  plugins.nvim-surround.enable = true;

  extraPlugins = [
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
  ];
}
