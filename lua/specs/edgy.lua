return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		enabled = false,
		config = function()
			local opts = {
				options = {
					right = {
						size = 40,
					}
				},
				animate = {
					enabled = false,
				},
				--- @type Edgy.View.Opts[]
				left = {
					{
						title = 'File Tree',
						ft = 'NvimTree',
						size = { height = 0.5 },
					},
				},
				right = {
					{
						title = 'Symbols',
						filter = function(buf, win)
							return vim.w[win].trouble and
								vim.w[win].trouble.mode == 'symbols'
						end,
						ft = 'trouble',
						size = { height = 0.7 }
					},
					{
						title = 'CTags',
						ft = 'aerial',
					},
				},
				--- @type Edgy.View.Opts[]
				bottom = {
					{
						title = 'Diagnostics',
						filter = function(buf, win)
							return vim.w[win].trouble and
								vim.w[win].trouble.mode == 'diagnostics'
						end,
						ft = 'trouble',
						open = 'Trouble diagnostics toggle'
					},
					{
						title = 'LSP',
						filter = function(buf, win)
							return vim.w[win].trouble and
								vim.w[win].trouble.mode == 'lsp'
						end,
						ft = 'trouble',
						open = 'Trouble lsp toggle'
					},
					{
						title = 'Quick Fix',
						filter = function(buf, win)
							return vim.w[win].trouble and
								vim.w[win].trouble.mode == 'qflist'
						end,
						ft = 'trouble',
						open = 'Trouble qflist toggle'
					},

				},
				close_when_all_hidden = false,
				exit_when_last = true,
			}

			require('edgy').setup(opts)
		end
	}
}
