return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
		config = function()
			local nvim_tree = require('nvim-tree')

			local swap_then_open_tab = function()
				local api = require("nvim-tree.api")
				local node = api.tree.get_node_under_cursor()
				vim.cmd("wincmd l")
				api.node.open.tab(node)
			end

			local on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.map.on_attach.default(bufnr)
				vim.keymap.set("n", "<C-t>", swap_then_open_tab,
					{ desc="Open: New Tab", buffer=bufnr, noremap=true,
					silent=true, nowait=true })
			end

			--- @type nvim_tree.config
			local opts = {
				on_attach = on_attach,
				hijack_cursor = true,
				disable_netrw = true,
				hijack_unnamed_buffer_when_opening = true,
				update_focused_file = {
					enable = true,
				},
				diagnostics = {
					enable = true,
					show_on_dirs = true,
					severity = {
						min = vim.diagnostic.severity.WARN
					},
				},
				modified = {
					enable = true,
					show_on_dirs = true,
				},
				view = {
					preserve_window_proportions = true,
				},
				renderer = {
					hidden_display = 'simple',
					icons = {
						glyphs = {
							folder = {
								arrow_closed = "▸",
								arrow_open = "▾",
							},
						},
					},
				},
			}

			nvim_tree.setup(opts)

			vim.keymap.set("n", "<leader>tt", '<cmd>NvimTreeToggle<CR>')
			vim.keymap.set("n", "<leader>tf", '<cmd>NvimTreeFocus<CR>')
		end,
	},
}
