{ pkgs, config, lib, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    
    # Don't use the "sensible" defaults!
    sensibleOnTop = false;
    
    # Set terminal with colours
    terminal = "screen-256color";

    # Use vi-style keybindings
    keyMode = "vi";

    # Fix escape key delay
    escapeTime = 0;
    
    # Use 24h clock
    clock24 = true;
    
    # Increase history limit
    historyLimit = 50000;

    # Set the prefix
    shortcut = "b";

    # Make first window be 1
    baseIndex = 1;
 };

 xdg.configFile = {
  "tmux/colours/solarized_dark.conf".source = ./colours/solarized_dark.conf;
};
}
