{
  config = {
    plugins.lsp = {
      enable = true;

      keymaps = {
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };
        lspBuf = {
          "<leader>ca" = "code_action";
          "<leader>cF" = "format";
          "<leader>ck" = "hover";
          "<leader>cK" = "signature_help";
          "<leader>cr" = "rename";
          "<leader>gd" = "definition";
          "<leader>gD" = "declaration";
          "<leader>gI" = "implementation";
          "<leader>gt" = "type_definition";
        };
        extra = [
          { key = "<leader>fs"; action = { __raw = "require('telescope.builtin').lsp_document_symbols"; }; options.desc = "Document symbols (LSP)"; }
          { key = "<leader>fS"; action = { __raw = "require('telescope.builtin').lsp_workspace_symbols"; }; options.desc = "Workspace symbols (LSP)"; }
          { key = "<leader>gr"; action = { __raw = "require('telescope.builtin').lsp_references"; }; options.desc = "References (LSP)"; }
        ];
      };
    };
  };
}
