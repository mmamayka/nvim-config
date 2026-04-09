vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.o.background = "dark"

vim.o.cmdheight=0

vim.diagnostic.config({
    virtual_text = true,
    signs = false,
    update_in_insert = false,
    severity_sort = true,
    underline = true,
})

vim.opt.number = true
vim.opt.relativenumber = true

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.api.nvim_set_keymap('n', '<leader> ', 'za', { noremap = true, silent = true })

vim.opt.colorcolumn = "80"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

vim.opt.wrap = false

vim.opt.splitkeep = "screen"
vim.opt.laststatus = 3
