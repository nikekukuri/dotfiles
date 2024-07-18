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
opt.scrolloff    = 10
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

cmd[[
if has('win32')
  if executable('pwsh')
    set shell=pwsh
  else
    set shell=powershell
  endif
endif
]]
-- for toggleterm.nvim
if fn.has('win32') then
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end
