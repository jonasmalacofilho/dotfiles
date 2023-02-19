--[[
Options that affect behavior.
--]]

-- Set leader (must come before plugins are required).
vim.g.mapleader = " "

-- Auto read and write files.
vim.opt.autoread = true
vim.opt.autowrite = true

-- Ignore case in all-lowercase patterns.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Default tab width.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.expandtab = true

-- Tab width overrides for specific file types.
vim.cmd [[autocmd FileType lua,vim,yaml setlocal tabstop=2]]
vim.cmd [[autocmd FileType c setlocal tabstop=8 softtabstop=8 noexpandtab]]

-- Enable mouse support on some modes.
vim.opt.mouse =  { n = true, v = true, i = true }

-- Don't honor vim modelines in files.
vim.opt.modeline = false

-- Spell by default (assumes undercurls are available).
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.spellfile = "~/.config/nvim/spell/personal.utf-8.add"

-- Threat splits as auxiliary.
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Reuse existing window or tab with target buffer.
vim.opt.switchbuf = { "useopen", "usetab" }

-- Make hardcopies with line numbers and roughly 100 columns; disable syntax highlight since it
-- doesn't seem to work with my printer.
vim.opt.printfont = "courier:h08"
vim.opt.printoptions = "left:5pc,number:y,syntax:n"

-- Set the default text width to reasonable values (in 2023).
vim.opt.textwidth = 100

--[[
Options that affect appearance.
--]]

-- Highlight common column threshold(s). In 2023, 80 columns is rarely relevant, even the Linux
-- kernel has been using 100 columns for a while.
vim.opt.colorcolumn = { 100 }

-- Show tabs, trailing space and nbsp.
vim.opt.list = true

-- Use relative numbers on all but current line.
vim.opt.number = true
vim.opt.relativenumber = true

-- Ensure there's always some context visible.
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

-- Avoid distracting popping of the sign column.
vim.opt.signcolumn = "yes"

-- Enable 24-bit color.
vim.opt.termguicolors = true

-- Show filename on window title.
vim.opt.title = true
