vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.opt.background = "dark"

vim.opt.cmdheight=0

vim.diagnostic.config({
    virtual_text = true,
    signs = false,
    update_in_insert = false,
    severity_sort = true,
    underline = true,
})

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.colorcolumn = "80"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

vim.opt.wrap = false

vim.opt.splitkeep = "screen"
vim.opt.laststatus = 3
