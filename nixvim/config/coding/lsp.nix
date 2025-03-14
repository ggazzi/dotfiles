{
  plugins = {
    # Status updates for LSP
    fidget.enable = true;

    # Auto-format on save
    lsp-format.enable = true;

    # Enable completions from LSP
    cmp-nvim-lsp.enable = true;
    cmp.settings.sources = [{ name = "nvim_lsp"; }];

    # Add nice pictograms to LSP completions
    lspkind.enable = true;

    lsp = {
      enable = true;

      keymaps = {
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };
        lspBuf = {
          "gd" = { action = "definition"; desc = "Definition (LSP)"; };
          "gD" = { action = "declaration"; desc = "Declaration (LSP)"; };
          "gI" = { action = "implementation"; desc = "Implementation (LSP)"; };
          "gt" = { action = "type_definition"; desc = "Type definition (LSP)"; };
          "<leader>ca" = { action = "code_action"; desc = "Code action (LSP)"; };
          "<leader>cF" = { action = "format"; desc = "Format (LSP)"; };
          "<leader>ck" = { action = "hover"; desc = "Hover documentation (LSP)"; };
          "<leader>cK" = { action = "signature_help"; desc = "Signature documentation (LSP)"; };
          "<leader>cr" = { action = "rename"; desc = "Rename (LSP)"; };
        };
        extra = [
          { key = "<leader>fs"; action = { __raw = "require('telescope.builtin').lsp_document_symbols"; }; options.desc = "Document symbols (LSP)"; }
          { key = "<leader>fS"; action = { __raw = "require('telescope.builtin').lsp_workspace_symbols"; }; options.desc = "Workspace symbols (LSP)"; }
          { key = "gr"; action = { __raw = "require('telescope.builtin').lsp_references"; }; options.desc = "References (LSP)"; }
        ];
      };

      onAttach = ''
        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(
          bufnr,
          'Format',
          function(_) vim.lsp.buf.format() end,
          { desc = 'Format current buffer with LSP' }
        )
      '';
    };
  };
}
