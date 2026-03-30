return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		build = ':TSUpdate',
		config = function()
			opts = {
				install_dir = vim.fn.stdpath('data') .. '/site'
			}
			local treesitter = require('nvim-treesitter')
			treesitter.setup(opts)
			treesitter.install({'c', 'cpp', 'python', 'cmake', 'devicetree',
				'diff', 'disassembly', 'git_config', 'git_rebase',
				'gitattributes', 'gitcommit', 'gitignore',
				'json', 'kconfig', 'linkerscript',
				'lua', 'make', 'markdown', 'objdump', 'printf',
				'regex', 'tcl', 'zsh', 'bash', 'awk'})
		end,
	},
}
