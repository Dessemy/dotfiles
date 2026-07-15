-- lua/config/options.lua
-- Sane defaults for a modern editing experience.

local opt = vim.opt

-- Leader keys (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable unused remote-plugin providers. Nothing in this config uses the
-- Perl/Ruby/Python3 hosts, so this silences their checkhealth warnings.
-- Do NOT disable the Node provider: Mason needs real node/npm on $PATH to
-- install several LSP servers (pyright, ts_ls, html, cssls, jsonls, bashls).
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.pumheight = 10
opt.showmode = false -- status line plugin shows mode instead

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Files / backups
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.updatetime = 250
opt.timeoutlen = 300
opt.autoread = true

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share system clipboard
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true -- ask to save instead of erroring on :q with unsaved changes
opt.whichwrap:append("<>[]hl")

-- Appearance details
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }

-- Encoding
opt.fileencoding = "utf-8"

-- Global statusline (one status line for all splits)
opt.laststatus = 3
