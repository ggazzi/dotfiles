{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
    ./buffers-windows.nix
    ./filetree.nix
    ./keys.nix
  ];

  colorschemes.catppuccin.enable = true;
  plugins = {
    lualine.enable = true;
  };
}
