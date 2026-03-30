return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",

		config = function()
			local opts = {
				enable_autosnippets = true,
			}
			require('luasnip').setup(opts)

			require("luasnip.loaders.from_lua").load({
				paths = vim.fn.stdpath('config') .. 'LuaSnip',
			})
		end,
	}
}
