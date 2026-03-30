return {
	{
		'civitasv/cmake-tools.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
			'mfussenegger/nvim-dap',
			'rcarriga/overseer.nvim',
		},
		config = function()
			require('cmake-tools').setup({
				cmake_regenerate_on_save = false,
				cmake_executor = {
					opts = {
						auto_close_when_success = false,
					},
				},
			})
		end,
	},
}
