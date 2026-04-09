


return {
	{
		'patrickpichler/hovercraft.nvim',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
		},
		config = function()
			local opts = {
				providers = {
					providers = {
						{
							"NumInfo",
							require("utils.hc-numprovider").new()
						},
						{
							'LSP',
							require('hovercraft.provider.lsp.hover').new(),
						},
						{
							'Diagnostic',
							require('hovercraft.provider.diagnostics').new()
						},
						{
							"Blame",
							require('hovercraft.provider.git.blame').new()
						},
						{
							'Dictionary',
							require('hovercraft.provider.dictionary').new(),
						},
					}
				}
			}
			require('hovercraft').setup(opts)
		end,
		keys = {
			{ "K", function()
				local hovercraft = require("hovercraft")

				if hovercraft.is_visible() then
					hovercraft.enter_popup()
				else
					hovercraft.hover()
				end
			end },
		},
	}
}
