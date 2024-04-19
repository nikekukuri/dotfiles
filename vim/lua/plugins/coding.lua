--- TODO: move utils
_G.nike = {}
local fs = {}
nike.fs = fs

---@param fname string
---@return string
function fs.read(fname)
  local fd = assert(vim.uv.fs_open(fname, "r", 292)) -- 0444
  local stat = assert(vim.uv.fs_fstat(fd))
  local buffer = assert(vim.uv.fs_read(fd, stat.size, 0))
  assert(vim.uv.fs_close(fd))
  return buffer
end

local nvim_cmp_config = function()
  --local lspkind = require('lspkind')
  local cmp = require('cmp')
  cmp.setup({
    --formatting = {
    --  format = lspkind.cmp_format({
    --    mode = 'symbol',
    --    maxwidth = 50,
    --    ellipsis_char = '...',
    --    show_labelDetails = true,
    --  })
    --},
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
      ['<Tab>'] = cmp.mapping.complete(),
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

  ---- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  --cmp.setup.cmdline({ '/', '?' }, {
  --  mapping = cmp.mapping.preset.cmdline(),
  --  sources = {
  --    { name = 'buffer' }
  --  }
  --})

  ---- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  --cmp.setup.cmdline(':', {
  --  mapping = cmp.mapping.preset.cmdline(),
  --  sources = cmp.config.sources({
  --    { name = 'path' }
  --  }, {
  --    { name = 'cmdline' }
  --  }),
  --  matching = { disallow_symbol_nonprefix_matching = false }
  --})
end

local vsnip_config = function()
  vim.g.vsnip_snippet_dir = vim.fn.expand("~/dotfiles/vim/snippet/")
  imap("<Tab>", function()
    if vim.fn['vsnip#jumpable(1)']() then
      return "<Plug>(vsnip-jump-next)"
    else
      return "<Tab>"
    end
  end, { expr = true, remap = true })
  imap("<S-Tab>", function()
    if vim.fn['vsnip#jumpable(1)']() then
      return "<Plug>(vsnip-jump-next)"
    else
      return "<Tab>"
    end
  end, { expr = true, remap = true })
  vim.g.vsnip_filetypes = {}
  vim.g.vsnip_filetypes.typescriptreact = { 'typescript' }
 end

return {
  {
    'hrsh7th/nvim-cmp',
    -- module = { "cmp" },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/cmp-cmdline' },
      { 'onsails/lspkind.nvim' },
      {
        'hrsh7th/vim-vsnip',
        config = vsnip_config,
        enabled = false,
      },
    },
    config = nvim_cmp_config,
    event = { 'InsertEnter' },
  },
  {
    'monaqa/dial.nvim',
    config = function()
      local dial = require("dial.map")
      nmap("<C-a>", dial.inc_normal())
      nmap("<C-x>", dial.dec_normal())
      nmap("g<C-a>", dial.inc_normal())
      nmap("g<C-a>", dial.dec_normal())
      vmap("<C-a>", dial.inc_visual())
      vmap("<C-x>", dial.dec_visual())
      vmap("g<C-a>", dial.inc_gvisual())
      vmap("g<C-x>", dial.dec_gvisual())
    end
  },

  {
    'machakann/vim-sandwich'
  },

  {
    'thinca/vim-qfreplace',
    event = { 'BufNewFile', 'BufRead' }
  },

  {
    'junegunn/vim-easy-align',
    config = function()
      nmap('ga', '<Plug>(EasyAlign)')
      vmap('ga', '<Plug>(EasyAlign)')
    end
  },

  {
    'vim-skk/skkeleton',
    dependencies = {
      'vim-denops/denops.vim',
    },
    config = function()
      imap('<C-j>', '<Plug>(skkeleton-toggle)')
      cmap('<C-j>', '<Plug>(skkeleton-toggle)')

      vim.fn["denops#plugin#wait_async"]("skkeleton", function()
        vim.g["skkeleton#mapped_keys"] = { "<C-l>" }
        vim.fn["skkeleton#register_keymap"]("input", "[", "katakana")
        vim.fn["skkeleton#register_keymap"]("input", "'", "disable")
        vim.fn["skkeleton#register_keymap"]("input", "<C-l>", "zenkaku")
        vim.fn["skkeleton#register_keymap"]("input", ";", "henkanPoint")
        local path = vim.fn.expand("~/.config/skk/azik_kanatable.json")
        local buffer = nike.fs.read(path)
        local kanaTable = vim.json.decode(buffer)
        kanaTable[" "] = "henkanFirst"
        vim.fn["skkeleton#register_kanatable"]("azik", kanaTable, true)

        vim.fn["skkeleton#config"]({
          kanaTable = "azik",
          eggLikeNewline = true,
          keepState = true,
          globalDictionaries = {
            vim.fn.expand("~/.config/skk/SKK-JISYO.L")
          },
        })

        vim.fn["skkeleton#initialize"]()
      end)

    end
  },
  {
    "delphinus/skkeleton_indicator.nvim",

    init = function()
      require("skkeleton_indicator").setup{
        nord = function(colors)
          api.set_hl(0, "SkkeletonIndicatorEiji", { fg = colors.cyan, bg = colors.dark_black, bold = true })
          api.set_hl(0, "SkkeletonIndicatorHira", { fg = colors.dark_black, bg = colors.green, bold = true })
          api.set_hl(0, "SkkeletonIndicatorKata", { fg = colors.dark_black, bg = colors.yellow, bold = true })
          api.set_hl(0, "SkkeletonIndicatorHankata", { fg = colors.dark_black, bg = colors.magenta, bold = true })
          api.set_hl(0, "SkkeletonIndicatorZenkaku", { fg = colors.dark_black, bg = colors.cyan, bold = true })
          api.set_hl(0, "SkkeletonIndicatorAbbrev", { fg = colors.white, bg = colors.red, bold = true })
        end,
      }
    end,

    ---@type SkkeletonIndicatorOpts
    opts = { fadeOutMs = 0, ignoreFt = { "dropbar_menu" } },
  },

  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    config = function()
      require("nvim-autopairs").setup({ map_c_h = true })
    end,
  },
}
