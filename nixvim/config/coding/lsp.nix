{
  plugins = {
    # Status updates for LSP
    fidget.enable = true;

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
    };
  };
}
