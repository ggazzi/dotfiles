{
  imports = [
    ./bufferline.nix
    ./keys.nix
    ./navigation
  ];

  colorschemes.catppuccin.enable = true;
  plugins = {
    lualine.enable = true;
  };
}
