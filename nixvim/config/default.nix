{
  imports = [
    ../plugins

    ./appearance
    ./coding
    ./keys.nix
    ./navigation
  ];

  opts = {
    # Make sure files are auto-saved and loaded all the time
    autowriteall = true;
    autoread = true;
    hidden = true;
    updatetime = 200;

    # We don't need swapfiles/recovery if we're saving all the time
    swapfile = false;
  };

  # Ensure files are saved as soon as we're not working on them
  autoCmd = [
    {
      event = "BufHidden";
      command = "silent! write";
    }
    {
      event = "FocusLost";
      command = "silent! wall";
    }
  ];
}
