{
  imports = [
    ../plugins
    ./bufferline.nix
    ./coding
    ./keys.nix
    ./navigation
  ];

  colorschemes.catppuccin.enable = true;
  plugins = {
    lualine.enable = true;
  };
}
