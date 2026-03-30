return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			'BurntSushi/ripgrep',
		},
		config = function()
			local opts = {
				defaults = {
					selection_strategy = "follow",
					scroll_strategy = "limit",
					winblend = function() return 30 end,
					initial_mode = 'normal',
					path_display = {'smart'},
					dynamic_preview_title = true,
				},
				pickers = {
					live_grep = {
						initial_mode = 'insert',
					},
				},
			}

			local telescope = require('telescope')
			local builtin = require('telescope.builtin')

			telescope.setup(opts)

			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
			vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		end,
	},
}
