{
  programs.nixvim.plugins.copilot-lua = {
    enable = true;

    settings = {
      panel.enabled = false;
      suggestion = {
        enabled = true;
        auto_trigger = true;
        debounce = 90;
        hide_during_completion = true;
        keymap = {
          accept = "<C-l>";
        };
      };
    };
  };
}
