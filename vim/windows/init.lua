-- clone from https://github.com/skanehira/dotfiles
---@diagnostic disable: need-check-nil

-- alias to vim's objects
g = vim.g
opt = vim.opt
cmd = vim.cmd
fn = vim.fn
api = vim.api

-- disable default plugins
local disable_plugins = {
  "loaded_gzip",
  "loaded_shada_plugin",
  "loadedzip",
  "loaded_spellfile_plugin",
  "loaded_tutor_mode_plugin",
  "loaded_gzip",
  "loaded_tar",
  "loaded_tarPlugin",
  "loaded_zip",
  "loaded_zipPlugin",
  "loaded_rrhelper", "loaded_2html_plugin",
  "loaded_vimball",
  "loaded_vimballPlugin",
  "loaded_getscript",
  "loaded_getscriptPlugin",
  "loaded_logipat",
  "loaded_matchparen",
  "loaded_man",
  "loaded_netrw",
  "loaded_netrwPlugin",
  "loaded_netrwSettings",
  "loaded_netrwFileHandlers",
  "loaded_logiPat",
  "did_install_default_menus",
  "did_install_syntax_menu",
  "skip_loading_mswin",
}

for _, name in pairs(disable_plugins) do
  g[name] = true
end

-- map functions
_G['map'] = function(mode, lhs, rhs, opt)
  vim.keymap.set(mode, lhs, rhs, opt or { silent = true })
end

for _, mode in pairs({ 'n', 'v', 'i', 'o', 'c', 't', 'x', 't' }) do
  _G[mode .. 'map'] = function(lhs, rhs, opt)
    map(mode, lhs, rhs, opt)
  end
end

-- options
cmd('filetype plugin indent on')
cmd('syntax enable')

g.mapleader      = " "
opt.breakindent  = true
opt.number       = false
opt.incsearch    = true
opt.ignorecase   = true
opt.smartcase    = true
opt.hlsearch     = true
opt.autoindent   = true
opt.smartindent  = true
opt.virtualedit  = "block"
opt.showtabline  = 1
opt.tabstop      = 2
opt.shiftwidth   = 2
opt.softtabstop  = 2
opt.completeopt  = 'menu,menuone,noselect'
opt.laststatus   = 3
opt.scrolloff    = 100
opt.cursorline   = true
opt.helplang     = 'ja'
opt.autowrite    = true
opt.swapfile     = false
opt.showtabline  = 1
-- opt.diffopt   = 'vertical,internal'
-- opt.wildcharm = ('<Tab>'):byte()
opt.tabstop      = 2
opt.shiftwidth   = 2
opt.softtabstop  = 2
opt.grepprg      = 'rg --vimgrep'
opt.grepformat   = '%f:%l:%c:%m'
opt.mouse        = 'a'
opt.clipboard:append({ fn.has('mac') == 1 and 'unnamed' or 'unnamedplus' })
opt.termguicolors = true
--opt.shell = "C:\\Program Files\\PowerShell\\7-preview\\pwsh.exe"
opt.shell = "pwsh.exe"



-- file indent
local filetype_indent_group = api.nvim_create_augroup('fileTypeIndent', { clear = true })
local file_indents = {
  {
    pattern = 'make',
    command = 'setlocal tabstop=8 shiftwidth=8 noexpandtab'
  },
  {
    pattern = 'go',
    command = 'setlocal tabstop=4 shiftwidth=4'
  },
  {
    pattern = 'rust',
    command = 'setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab'
  },
  {
    pattern = { 'javascript', 'typescriptreact', 'typescript', 'vim', 'lua', 'yaml', 'json', 'sh', 'zsh', 'markdown' },
    command = 'setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab'
  },
}

-- grep window
api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '*grep*',
  command = 'cwindow',
  group = api.nvim_create_augroup('grepWindow', { clear = true }),
})

for _, indent in pairs(file_indents) do
  api.nvim_create_autocmd('FileType', {
    pattern = indent.pattern,
    command = indent.command,
    group = filetype_indent_group
  })
end

-- grep window
api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '*grep*',
  command = 'cwindow',
  group = api.nvim_create_augroup('grepWindow', { clear = true }),
})

-- restore cursorline
api.nvim_create_autocmd('BufReadPost',
  {
    pattern = '*',
    callback = function()
      cmd([[
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g'\""
    endif
    ]] )
    end,
    group = api.nvim_create_augroup('restoreCursorline', { clear = true })
  })

-- persistent undo
local ensure_undo_dir = function()
  local undo_path = fn.expand('~/.config/nvim/undo')
  if fn.isdirectory(undo_path) == 0 then
    fn.mkdir(undo_path, 'p')
  end
  opt.undodir = undo_path
  opt.undofile = true
end
ensure_undo_dir()

-- start insert mode when termopen
api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    cmd('startinsert')
    cmd('setlocal scrolloff=0')
  end,
  group = api.nvim_create_augroup("neovimTerminal", { clear = true }),
})

-- auto mkdir
local auto_mkdir = function(dir)
  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, 'p')
  end
end
api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    auto_mkdir(fn.expand('<afile>:p:h'))
  end,
  group = api.nvim_create_augroup('autoMkdir', { clear = true })
})

-- key mappings

-- text object
omap('\'', 'i\'')
omap('"', 'i"')
omap('9', 'i(')
omap('[', 'i[')
omap('{', 'i{')
omap('a9', 'a(')

nmap('v9', 'vi(')
nmap('v[', 'vi[')
nmap('v{', 'vi{')
nmap('va9', 'va(')
-- better `ct`
nmap('cm', 'ct')

-- easy type `{` and `}`
nmap('<C-j>', '}')
nmap('<C-k>', '{')

-- emacs like
imap('<C-k>', '<C-o>C')
imap('<C-f>', '<Right>')
imap('<C-b>', '<Left>')
imap('<C-e>', '<C-o>A')
imap('<C-a>', '<C-o>I')

nmap('<Leader>ml', ':MemoList<CR>')
nmap('<Leader>mn', ':MemoNew<CR>')

-- swap ; and : in n, v mode
-- nmap(';', ':')
-- nmap(':', ';')
-- vmap(';', ':')
-- vmap(':', ';')
nmap('\'', ':')
vmap('\'', ':')

xmap("*",
  table.concat {
    -- 選択範囲を検索クエリに用いるため、m レジスタに格納。
    -- ビジュアルモードはここで抜ける。
    [["my]],
    -- "m レジスタの中身を検索。
    -- ただし必要な文字はエスケープした上で、空白に関しては伸び縮み可能とする
    [[/\V<C-R><C-R>=substitute(escape(@m, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>]],
    -- 先ほど検索した範囲にカーソルが移るように、手前に戻す
    [[N]],
  },
  {}
)

-- help
api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "nnoremap <buffer> <silent>q :bw!<CR>",
  group = api.nvim_create_augroup("helpKeymaps", { clear = true }),
})

-- command line
-- cmap defaults silent to true, but passes an empty setting because the cursor is not updated
cmap('<C-b>', '<Left>', {})
cmap('<C-f>', '<Right>', {})
cmap('<C-a>', '<Home>', {})
cmap('<Up>', '<C-p>')
cmap('<Down>', '<C-n>')
cmap('<C-n>', function()
  return fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })
cmap('<C-p>', function()
  return fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })
api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    nmap('q', '<Cmd>q<CR>', { silent = true, buffer = true })
  end,
  group = api.nvim_create_augroup("qfInit", { clear = true }),
})

-- paste with <C-v>
map({ 'c', 'i' }, '<C-v>', 'printf("<C-r><C-o>%s", v:register)', { expr = true })

-- other keymap
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  nmap('<Leader>.', ':tabnew ~\\Appdata\\Local\\nvim\\init.lua<CR>')
else
  nmap('<Leader>.', ':tabnew ~/.config/nvim/init.lua<CR>')
end

nmap('<Leader>w', ':w')
nmap('j', 'gj')
nmap('k', 'gk')
nmap('R', 'gR')
nmap('*', '*N')
nmap('x', '"_x')
nmap('s', '"_s')
nmap('c', '"_c')
nmap('<Esc><Esc>', '<Cmd>nohlsearch<CR>')
nmap('H', '^')
nmap('L', 'g_')
nmap('<Leader><Tab>', '%')
nmap('sv', ':vsplit<CR><C-w>l')
nmap('ss', ':split<CR><C-w>j')
nmap('sh', '<C-w>h')
nmap('sj', '<C-w>j')
nmap('sk', '<C-w>k')
nmap('sl', '<C-w>l')
nmap('[b', '<Cmd>bnext<CR>')
nmap(']b', '<Cmd>bprevious<CR>')
nmap('<', '<<')
nmap('>', '>>')
omap('H', '^')
omap('L', 'g_')
omap('<Tab>', '%')
nmap('<C-l>', 'gt')
nmap('<C-h>', 'gT')
nmap('<Leader>tt', [[:tabnew | terminal<CR>]])
tmap('<C-]>', [[<C-\><C-n>]])
vmap('H', '^')
vmap('L', 'g_')
vmap('<Tab>', '%')

-- ############################# plugin config section ###############################
-- MemoList
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  g['memolist_path'] = "~\\note\\docs\\notes"
else
  g['memolist_path'] = "~/note/docs/notes"
end

-- noice.nvim
local noice_config = function()
  local noice = require("noice")
  noice.setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  })
end

-- vim-easy-align
local vim_easy_align_config = function()
  nmap('ga', '<Plug>(EasyAlign)')
  vmap('ga', '<Plug>(EasyAlign)')
end

-- nvim-cmp
local nvim_cmp_config = function()
  local cmp = require('cmp')
  cmp.setup({
    window = {
      -- completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      -- ['<Tab>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer', option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(api.nvim_list_wins()) do
            bufs[api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      } },
      { name = 'path' },
    },
    view = {
      entries = 'native'
    },
    snippet = {
      expand = function(args)
        fn['vsnip#anonymous'](args.body)
      end
    },
  })
end

-- lsp on attach
Lsp_on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  client.server_capabilities.semanticTokensProvider = nil
  api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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

  -- local augroup = api.nvim_create_augroup("LspFormatting", { clear = false })
  -- if client.supports_method("textDocument/formatting") then
  --   nmap(']f', vim.lsp.buf.format, { buffer = bufnr })
  --   if client.name == 'sumneko_lua' then
  --     return
  --   end
  --   api.nvim_create_autocmd("BufWritePre", {
  --     callback = function()
  --       organize_import()
  --       vim.lsp.buf.format()
  --     end,
  --     group = augroup,
  --     buffer = bufnr,
  --   })
  -- end
end

-- rust-tools.nvim
local rust_tools_config = function()
  local rt = require("rust-tools")
  rt.setup({
    server = {
      on_attach = function(client, bufnr)
        local bufopts = { silent = true, buffer = bufnr }
        Lsp_on_attach(client, bufnr)
        nmap('K', rt.hover_actions.hover_actions, bufopts)
        nmap('<Leader>gl', rt.code_action_group.code_action_group, bufopts)
        nmap('gO', function()
          vim.lsp.buf_request(0, 'experimental/externalDocs', vim.lsp.util.make_position_params(),
            function(err, url)
              if err then
                error(tostring(err))
              else
                fn.jobstart({ 'open', url })
              end
            end)
        end, bufopts)
      end,
      standalone = true,
      settings = {
        ['rust-analyzer'] = {
          -- files = {
          --   excludeDirs = { '/root/path/to/dir' },
          -- },
        }
      }
    },
    tools = {
      hover_actions = {
        border = {
          { '╭', 'NormalFloat' },
          { '─', 'NormalFloat' },
          { '╮', 'NormalFloat' },
          { '│', 'NormalFloat' },
          { '╯', 'NormalFloat' },
          { '─', 'NormalFloat' },
          { '╰', 'NormalFloat' },
          { '│', 'NormalFloat' },
        },
        -- auto_focus = true,
      },
    },
  })
end

-- color scheme config
local colorscheme_config = function()
  opt.termguicolors = true
  cmd([[
      colorscheme nightfox
      hi VertSplit guifg=#535353
      hi Visual ctermfg=159 ctermbg=23 guifg=#b3c3cc guibg=#384851
      hi DiffAdd guifg=#25be6a
      hi DiffDelete guifg=#ee5396
      ]])
end

-- bufferline.nvim
local bufferline_config = function()
  require('bufferline').setup({
    options = {
      mode = 'tabs',
      hover = {
        enabled = true,
      },
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return ' ' .. icon .. count
      end,
      indicator = {
        icon = '',
      },
      buffer_close_icon = 'x'
    }
  })
end

-- gina.vim
local gina_config = function()
  local gina_keymaps = {
    { map = 'nmap', buffer = 'status', lhs = 'gp', rhs = '<Cmd>Gina push<CR>' },
    { map = 'nmap', buffer = 'status', lhs = 'gr', rhs = '<Cmd>terminal gh pr create<CR>' },
    { map = 'nmap', buffer = 'status', lhs = 'gl', rhs = '<Cmd>Gina pull<CR>' },
    { map = 'nmap', buffer = 'status', lhs = 'cm', rhs = '<Cmd>Gina commit<CR>' },
    { map = 'nmap', buffer = 'status', lhs = 'ca', rhs = '<Cmd>Gina commit --amend<CR>' },
    { map = 'nmap', buffer = 'status', lhs = 'dp', rhs = '<Plug>(gina-patch-oneside-tab)' },
    { map = 'nmap', buffer = 'status', lhs = 'ga', rhs = '--' },
    { map = 'vmap', buffer = 'status', lhs = 'ga', rhs = '--' },
    { map = 'nmap', buffer = 'log', lhs = 'dd', rhs = '<Plug>(gina-changes-of)' },
    { map = 'nmap', buffer = 'branch', lhs = 'n', rhs = '<Plug>(gina-branch-new)' },
    { map = 'nmap', buffer = 'branch', lhs = 'D', rhs = '<Plug>(gina-branch-delete)' },
    { map = 'nmap', buffer = 'branch', lhs = 'p', rhs = '<Cmd>terminal gh pr create<CR>' },
    { map = 'nmap', buffer = 'branch', lhs = 'P', rhs = '<Cmd>terminal gh pr create<CR>' },
    { map = 'nmap', buffer = '/.*', lhs = 'q', rhs = '<Cmd>bw<CR>' },
  }
  for _, m in pairs(gina_keymaps) do
    fn['gina#custom#mapping#' .. m.map](m.buffer, m.lhs, m.rhs, { silent = true })
  end

  fn['gina#custom#command#option']('log', '--opener', 'new')
  fn['gina#custom#command#option']('status', '--opener', 'new')
  fn['gina#custom#command#option']('branch', '--opener', 'new')
  nmap('gs', '<Cmd>Gina status<CR>')
  nmap('gl', '<Cmd>Gina log<CR>')
  nmap('gm', '<Cmd>Gina blame<CR>')
  nmap('gb', '<Cmd>Gina branch<CR>')
  nmap('gu', ':Gina browse --exact --yank :<CR>')
  vmap('gu', ':Gina browse --exact --yank :<CR>')
end

-- telescope.vim
local telescope_config = function()
  require("telescope").load_extension("ui-select")
  local actions = require('telescope.actions')
  require('telescope').setup {
    pickers = {
      live_grep = {
        mappings = {
          i = {
            ['<C-o>'] = actions.send_to_qflist + actions.open_qflist,
            ['<C-l>'] = actions.send_to_loclist + actions.open_loclist,
          }
        }
      }
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown {}
      }
    }
  }
end

-- fern.vim
local fern_config = function()
  g['fern#renderer'] = 'nerdfont'
  g['fern#window_selector_use_popup'] = true
  g['fern#default_hidden'] = 1
  g['fern#default_exclude'] = '.git$'

  api.nvim_create_autocmd('FileType', {
    pattern = 'fern',
    callback = function()
      nmap('q', ':q<CR>', { silent = true, buffer = true })
      nmap('<C-x>', '<Plug>(fern-action-open:split)', { silent = true, buffer = true })
      nmap('<C-v>', '<Plug>(fern-action-open:vsplit)', { silent = true, buffer = true })
      nmap('<C-t>', '<Plug>(fern-action-tcd)', { silent = true, buffer = true })
    end,
    group = api.nvim_create_augroup('fernInit', { clear = true }),
  })
end

-- lsp config
local lsp_config = function()
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  require('mason-lspconfig').setup({
    automatic_installation = true
  })

  local lspconfig = require("lspconfig")

  -- mason-lspconfig will auto install LS when config included in lspconfig
  local lss = {
    'denols',
    'gopls',
    'rust_analyzer',
    'tsserver',
    'lua_ls',
    'golangci_lint_ls',
    'bashls',
    'yamlls',
    'jsonls',
    'vimls',
    'pylsp',
    'clangd',
  }

  local node_root_dir = lspconfig.util.root_pattern("package.json")
  local is_node_repo = node_root_dir(fn.getcwd()) ~= nil

  for _, ls in pairs(lss) do
    (function()
      -- use rust-tools.nvim to setup
      if ls == 'rust_analyzer' then
        return
      end

      local opts = {}

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
        if not is_node_repo then
          return
        end

        opts = {
          root_dir = lspconfig.util.root_pattern('package.json', 'node_modules'),
        }
      elseif ls == 'lua_ls' then
        opts = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT'
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
      end

      opts['on_attach'] = Lsp_on_attach

      lspconfig[ls].setup(opts)
    end)()
  end
end

-- gitsigns.nvim
local gitsigns_config = function()
  require('gitsigns').setup({
    current_line_blame = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      local opts = {
        buffer = bufnr,
        silent = true
      }
      -- Actions
      map({ 'n', 'x' }, ']g', ':Gitsigns stage_hunk<CR>', opts)
      map({ 'n', 'x' }, '[g', ':Gitsigns undo_stage_hunk<CR>', opts)
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', opts)
      nmap('mp', ':Gitsigns preview_hunk<CR>', opts)
    end
  })
end

-- lsp hover config
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
  border = "single"
})

-- translate.vim
local translate_config = function()
  nmap('gr', '<Plug>(Translate)')
  vmap('gr', '<Plug>(Translate)')
end

-- quickrun.vim
g['quickrun_config'] = {
  typescript = {
    command = 'deno',
    tempfile = '%{printf("%s.ts", tempname())}',
    cmdopt = '--no-check --unstable --allow-all',
    exec = { 'NO_COLOR=1 %C run %o %s' },
  },
  ['deno/terminal'] = {
    command = 'deno',
    tempfile = '%{printf("%s.ts", tempname())}',
    cmdopt = '--no-check --unstable --allow-all',
    exec = { '%C run %o %s' },
    type = 'typescript',
    runner = 'neoterm',
  },
  ['rust/cargo'] = {
    command = 'cargo',
    exec = '%C run --quiet %s %a',
  },
}

local quickrun_config = function()
  api.nvim_create_autocmd('FileType', {
    pattern = 'quickrun',
    callback = function()
      nmap('q', '<Cmd>bw!<CR>', { silent = true, buffer = true })
    end,
    group = api.nvim_create_augroup('quickrunInit', { clear = true }),
  })
end

-- vim-markdown
g['vim_markdown_folding_disabled'] = true

-- test.vim
-- local test_config = function()
--   g['test#javascript#denotest#options'] = { all = '--parallel --unstable -A' }
--   g['test#rust#cargotest#options'] = { all = '-- --nocapture' }
--   g['test#go#gotest#options'] = { all = '-v' }
--   nmap('<Leader>tn', '<Cmd>TestNearest<CR>')
-- end

-- open-browser.vim
local openbrowser_config = function()
  nmap('gop', '<Plug>(openbrowser-open)')
  xmap('gop', '<Plug>(openbrowser-open)')
end

-- lualine
local lualine_config = function()
  require('lualine').setup({
    sections = {
      lualine_c = {
        {
          'filename',
          path = 3,
        }
      }
    }
  })
end

-- treesitter config
local treesitter_config = function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'rust', 'go', 'gomod', 'sql', 'toml', 'yaml',
      'html', 'markdown', 'markdown_inline',
    },
    auto_install = true,
    highlight = {
      enable = true,
    }
  })
end

-- indent_blankline config
local indent_blankline = function()
  require("indent_blankline").setup({
    space_char_blankline = " ",
  })
end

-- ############################# lazy config section ###############################
-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy settings
require("lazy").setup({
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
			}
	},
  {
    'machakann/vim-sandwich'
  },
  {
    'thinca/vim-qfreplace',
    event = { 'BufNewFile', 'BufRead' }
  },
  -- {
  --   'folke/noice.nvim',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   config = noice_config,
  -- },
  {
    'junegunn/vim-easy-align',
    config = vim_easy_align_config,
  },
  {
    'vim-skk/skkeleton',
    init = function()
      api.nvim_create_autocmd('User', {
        pattern = 'skkeleton-initialize-pre',
        callback = function()
          vim.call('skkeleton#config', {
            globalJisyo = vim.fn.expand('~/.config/skk/SKK-JISYO.L'),
            eggLikeNewline = true,
            keepState = true
          })
        end,
        group = api.nvim_create_augroup('skkeletonInitPre', { clear = true }),
      })
    end,
    config = function()
      imap('<C-j>', '<Plug>(skkeleton-toggle)')
      cmap('<C-j>', '<Plug>(skkeleton-toggle)')
    end
  },
  {
    'lambdalisue/kensaku.vim'
  },
  {
    'lambdalisue/kensaku-search.vim',
    config = function()
      cmap('<CR>', '<Plug>(kensaku-search-replace)<CR>', {})
    end
  },
  {
    'thinca/vim-qfreplace',
    event = { 'QuickFixCmdPre' }
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = indent_blankline,
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'BufRead',
    config = function()
      require('lsp_signature').setup({})
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = gitsigns_config
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = lualine_config,
  },
  -- {
  --   'akinsho/bufferline.nvim',
  --   version = "v2.*",
  --   dependencies = 'kyazdani42/nvim-web-devicons',
  --   config = bufferline_config
  -- },
  {
    'EdenEast/nightfox.nvim',
    -- lazy = false,
    config = colorscheme_config,
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    event = { 'QuickFixCmdPre' }
  },
  {
    'simrat39/rust-tools.nvim',
    ft = { 'rust' },
    config = rust_tools_config,
    dependencies = {
      { 'neovim/nvim-lspconfig' },
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        config = function() require("mason").setup() end,
      },
    },
    config = lsp_config,
  },
  {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end,
  },
  {
    'hrsh7th/nvim-cmp',
    -- module = { "cmp" },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/vim-vsnip' },
    },
    config = nvim_cmp_config,
    event = { 'InsertEnter' },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = treesitter_config
  },
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    config = function()
      require("nvim-autopairs").setup({ map_c_h = true })
    end,
  },
  -- {
  --   'vim-test/vim-test',
  --   event = 'BufRead',
  --   config = test_config,
  -- },
  {
    'lambdalisue/fern-hijack.vim',
    dependencies = {
      'lambdalisue/fern.vim',
      cmd = 'Fern',
      config = fern_config,
    },
    init = function()
      nmap('<Leader>f', '<Cmd>Fern . -drawer<CR>', { silent = true })
    end
  },
  {
    'lambdalisue/gina.vim',
    config = gina_config,
  },
  {
    'lambdalisue/guise.vim',
  },
  {
    'simeji/winresizer',
    keys = {
      { '<C-e>', '<Cmd>WinResizerStartResize<CR>', desc = 'start window resizer' }
    },
  },
  { 'vim-denops/denops.vim' },
  {
    'thinca/vim-quickrun',
    dependencies = {
      { 'skanehira/quickrun-neoterm.vim' }
    },
    config = quickrun_config,
  },
  {
    'tyru/open-browser-github.vim',
    dependencies = {
      {
        'tyru/open-browser.vim',
        config = openbrowser_config,
      },
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    -- module = { "telescope" },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    init = function()
      local function builtin(name)
        return function(opt)
          return function()
            return require('telescope.builtin')[name](opt or {})
          end
        end
      end

      nmap('<C-p>', builtin 'find_files' {})
      nmap('mg', builtin 'live_grep' {})
      nmap('md', builtin 'diagnostics' {})
      nmap('mf', builtin 'current_buffer_fuzzy_find' {})
      nmap('mh', builtin 'help_tags' { lang = 'ja' })
      nmap('mo', builtin 'oldfiles' {})
      nmap('ms', builtin 'git_status' {})
    end,
    config = telescope_config,
  },
  -- for documentation
  { 'glidenote/memolist.vim', cmd = { 'MemoList', 'MemoNew' } },
  { 'godlygeek/tabular', event = 'BufRead' },
  -- { 'gyim/vim-boxdraw' }
  { 'mattn/vim-maketable', event = 'BufRead' },
  -- { 'shinespark/vim-list2tree' }
  {
    'skanehira/denops-translate.vim',
    config = translate_config
  },
  { 'vim-jp/vimdoc-ja' },
  { 'plasticboy/vim-markdown', ft = 'markdown' },
  { 'previm/previm', ft = 'markdown' },

  -- for develop vim plugins
  { 'LeafCage/vimhelpgenerator', ft = 'vim' },
  { 'lambdalisue/vital-Whisky', ft = 'vim' },
  { 'tweekmonster/helpful.vim' },
  { 'vim-jp/vital.vim' },
  { 'thinca/vim-themis', ft = 'vim' },
  { 'tyru/capture.vim' },
  { 'mattn/webapi-vim' },
})
