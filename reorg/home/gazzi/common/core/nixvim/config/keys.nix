{
  programs.nixvim = {
    globals.mapleader = " ";

    plugins.which-key = {
      enable = true;
    };

    opts = {
      # Make sure we have enough time for key sequences, but not too much
      timeoutlen = 1000;
    };
  };
}
