local lsp_on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  client.server_capabilities.semanticTokensProvider = nil
  --api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local bufopts = { silent = true, buffer = bufnr }
  nmap('K', vim.lsp.buf.hover, bufopts)
  nmap('gd', vim.lsp.buf.definition, bufopts)
  nmap('gi', vim.lsp.buf.implementation, bufopts)
  nmap('gr', vim.lsp.buf.references, bufopts)
  nmap('<Leader>rn', vim.lsp.buf.rename, bufopts)
  nmap(']d', vim.diagnostic.goto_next, bufopts)
  nmap('[d', vim.diagnostic.goto_prev, bufopts)
  nmap('<C-g><C-d>', vim.diagnostic.open_float, bufopts)
  if client.name == 'denols' then
    nmap('<C-]>', vim.lsp.buf.definition, bufopts)
  else
    opt.tagfunc = 'v:lua.vim.lsp.tagfunc'
  end
  map({ 'n', 'x' }, 'ma', vim.lsp.buf.code_action, bufopts)
  nmap('<Leader>gl', vim.lsp.codelens.run, bufopts)

  local organize_import = function() end
  local actions = vim.tbl_get(client.server_capabilities, 'codeActionProvider', "codeActionKinds")
  if actions ~= nil and vim.tbl_contains(actions, "source.organizeImports") then
    organize_import = function()
      vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    end
  end
  nmap('mi', organize_import)

  -- inlay hint default enable
  vim.lsp.inlay_hint.enable(bufnr, true)
  -- inlay hint toggle
  nmap('<Leader>gi', function()
    return vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
  end, { expr = true })

  -- format on save
  local format_sync_grp = vim.api.nvim_create_augroup("FormatOnSave", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function() vim.lsp.buf.format() end,
    group = format_sync_grp,
  })

  if client.supports_method("textDocument/formatting") then
    nmap(']f', vim.lsp.buf.format, { buffer = bufnr })
  end
end

-- lsp config
local lsp_config = function()
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  require('mason-lspconfig').setup({
    automatic_installation = true,
  })

  local lspconfig = require("lspconfig")

  -- mason-lspconfig will auto install LS when config included in lspconfig
  local lss = {
    'denols',
    'gopls',
    'rust_analyzer',
    'tsserver',
    'volar',
    'lua_ls',
    'golangci_lint_ls',
    -- 'eslint',
    'graphql',
    'bashls',
    'yamlls',
    'jsonls',
    'vimls',
    'pyright',
    'clangd',
  }

  local node_root_dir = lspconfig.util.root_pattern("package.json")
  local is_node_repo = node_root_dir(fn.getcwd()) ~= nil

  local is_other_than_win = require("rc.utils").is_other_than_win

  for _, ls in pairs(lss) do
    (function()
      local opts = {}

      -- use rustacean.nvim to setup other than Windows
      -- if ls == 'rust_analyzer' then
      --   if is_other_than_win then
      --     return
      --   end
      -- end

      if ls == 'denols' then
        -- dont start LS in nodejs repository
        if is_node_repo then
          return
        end
        opts = {
          cmd = { 'deno', 'lsp' },
          root_dir = lspconfig.util.root_pattern('deps.ts', 'deno.json', 'import_map.json', '.git'),
          init_options = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true,
                },
              },
            },
          },
        }
      elseif ls == 'tsserver' then
        lspconfig.tsserver.setup({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json'),
        })
      elseif ls == 'lua_ls' then
        opts = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                checkThirdParty = false,
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = api.nvim_get_runtime_file("", true),
              },
            },
          },
        }
      elseif ls == 'rust_analyzer' then
        opts = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                features = 'all'
              },
              check = {
                command = "clippy"
              },
              completion = {
                autoimport = {
                  enabled = true
                },
              },
              diagnostics = {
                experimental = {
                  enable = true,
                }
              }
            }
          }
        }
      elseif ls == 'pyright' then
        lspconfig.pyright.setup({
          singlle_file_mode = true,
        })
      end


      opts['on_attach'] = lsp_on_attach

      lspconfig[ls].setup(opts)
    end)()
  end
end

local none_ls_config = function()
  local null_ls = require('null-ls')
  -- sources setup
  local sources = {
    null_ls.builtins.formatting.prettier,
    -- Lua
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.diagnostics.fish,
  }
  null_ls.setup({
    sources = sources,
  })
end

return {
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile', 'BufEnter', 'BufNew' },
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        config = function()
          require("mason").setup()
          require("mason-lspconfig").setup()
        end,
      },
    },
    config = lsp_config,
  },
  {
    'nvimtools/none-ls.nvim',
    config = none_ls_config,
    dependencies = { 'williamboman/mason.nvim' }
  },
}
