{
  imports = [
    ./statusline.nix
  ];

  colorschemes.catppuccin.enable = true;

  plugins = {
    web-devicons.enable = true;
  };

  opts = {
    # Make sure the cursor is far enough away from window border
    scrolloff = 5;
  };
}
