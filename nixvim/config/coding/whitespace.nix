{
  plugins = {
    # Detect tabstop and shiftwidth automatically
    sleuth.enable = true;

    trim = {
      enable = true;
      settings = {
        highlight = true;
        trim_on_write = true;
        trim_trailing = true;
        trim_last_line = true;
      };
    };
  };
}
