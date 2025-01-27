{ mylib, ... }:

{
  # plugins.copilot-vim.enable = true;

  plugins.copilot-lua = {
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

  plugins.which-key.settings.spec = [
    { __unkeyed-1 = "<leader>cC"; group = "Copilot"; }
  ];

  keymaps = mylib.keymapGroup "<leader>cC" [
    { key = "e"; action = ":Copilot enable<CR>"; options.desc = "Enable Copilot"; }
    { key = "d"; action = ":Copilot disable<CR>"; options.desc = "Disable Copilot"; }
    { key = "s"; action = ":Copilot status<CR>"; options.desc = "Show Copilot status"; }
    { key = "C"; action = ":Copilot panel<CR>"; options.desc = "Show panel with up to 10 completions"; }
  ];
}
