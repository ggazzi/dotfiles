-- Status updates for LSP
require("fidget").setup({})

--  This function gets run when an LSP connects to a particular buffer.
local wk = require('which-key')
local on_attach = function(_, bufnr)
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(
    bufnr,
    'Format',
    function(_) vim.lsp.buf.format() end,
    { desc = 'Format current buffer with LSP' }
  )

  -- Local Keybindings for the buffer that has an LSP
  wk.register({
    ['g'] = {
      D = { vim.lsp.buf.declaration, 'Declaration (LSP)' },
      d = { vim.lsp.buf.definition, 'Definition (LSP)' },
      r = { require('telescope.builtin').lsp_references, 'References (LSP)' },
      I = { vim.lsp.buf.implementation, 'Implementation (LSP)' },
      t = { vim.lsp.buf.type_definition, 'Type definition (LSP)' },
    },
    ['<Leader>f'] = {
      s = { require('telescope.builtin').lsp_document_symbols, 'Document symbols (LSP)' },
      S = { require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols (LSP)' },
    },
    ['<Leader>c'] = {
      r = { vim.lsp.buf.rename, 'Rename (LSP)' },
      a = { vim.lsp.buf.code_action, 'Code Action (LSP)' },
      k = { vim.lsp.buf.hover, 'Hover documentation (LSP)' },
      K = { vim.lsp.buf.signature_help, 'Signature documentation (LSP)' },
    },
  }, { buffer = bufnr })
end

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Language servers that are not managed by mason
local servers = {
  nil_ls = {}
}

local lspconfig = require('lspconfig');
for lsp, settings in pairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = settings,
  }
end

-- Language servers to be installed using mason
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local mason_servers = {
  tsserver = {},
  -- Do not install solargraph since it's a gem. Do this per project instead.
  -- solargraph = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
    },
  },
}

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = vim.tbl_keys(mason_servers),

  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = mason_servers[server_name],
      }
    end,
  }
})
