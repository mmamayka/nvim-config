return {
	{
		'neogitorg/neogit',
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", function() require('neogit').open({ kind = 'floating' }) end, desc = "Show Neogit UI" },
			{ "<leader>gc", function() require('neogit').open({ "commit", kind = 'floating'}) end }
		}
	},
}
