Lsp_on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  client.server_capabilities.semanticTokensProvider = nil
  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local bufopts = { silent = true, buffer = bufnr }
  nmap('gd', vim.lsp.buf.definition, bufopts)
  nmap('gi', vim.lsp.buf.implementation, bufopts)
  nmap('gr', vim.lsp.buf.references, bufopts)
  nmap('<Leader>rn', vim.lsp.buf.rename, bufopts)
  nmap(']d', vim.diagnostic.goto_next, bufopts)
  nmap('[d', vim.diagnostic.goto_prev, bufopts)

  -- auto format when save the file
  local organize_import = function() end
  local actions = vim.tbl_get(client.server_capabilities, 'codeActionProvider', "codeActionKinds")
  if actions ~= nil and vim.tbl_contains(actions, "source.organizeImports") then
    organize_import = function()
      vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    end
  end
  nmap('mi', organize_import)

  if client.supports_method("textDocument/formatting") then
    nmap(']f', vim.lsp.buf.format, { buffer = bufnr })
  end
end

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
  },
  -- LSP configuration
  server = {
    on_attach = Lsp_on_attach,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}

local config = function()
  -- replace `J` command in rust
  nmap('J', '<Cmd>RustLsp hover actions<CR>')

  -- Hover action
  nmap('K', '<Cmd>RustLsp hover actions<CR>')
  -- Diagnostic
  nmap('<C-g><C-d>', '<Cmd>RustLsp explainError<CR>')

  vim.api.nvim_create_user_command('OpenCargoToml', function()
    vim.cmd.RustLsp('openCargo')
  end, {})
  vim.api.nvim_create_user_command('ViewHir', function()
    vim.cmd.RustLsp { 'view', 'hir' }
  end, {})
  vim.api.nvim_create_user_command('ViewMir', function()
    vim.cmd.RustLsp { 'view', 'mir' }
  end, {})
end

return {
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
    config = config,
  },
}
