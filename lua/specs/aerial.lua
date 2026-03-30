return {
	{
		'stevearc/aerial.nvim',
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
		config = function()
			local opts = {
				backends = {
					'treesitter',
					'lsp',
					'markdown',
					'asciidoc',
					'man'
				},
				layout = {
					max_width = { 40, 0.3 },
					preserve_equality = true,
					min_width = 20,
				},
				autojump = true,
			}
			require('aerial').setup(opts)
		end,
	},
}
