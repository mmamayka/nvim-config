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

			vim.api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
				nested = false,
				callback = function(e)
					local tree = require('nvim-tree.api').tree

					-- Nothing to do if tree is not opened
					if not tree.is_visible() then
						return
					end

					-- How many focusable windows do we have? (excluding e.g. incline status window)
					local winCount = 0
					for _,winId in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_config(winId).focusable then
							winCount = winCount + 1
						end
					end

					-- We want to quit and only one window besides tree is left
					if e.event == 'QuitPre' and winCount == 2 then
						vim.api.nvim_cmd({cmd = 'qall'}, {})
					end

					-- :bd was probably issued an only tree window is left
					-- Behave as if tree was closed (see `:h :bd`)
					if e.event == 'BufEnter' and winCount == 1 then
						-- Required to avoid "Vim:E444: Cannot close last window"
						vim.defer_fn(function()
							-- close nvim-tree: will go to the last buffer used before closing
							tree.toggle({find_file = true, focus = true})
							-- re-open nivm-tree
							tree.toggle({find_file = true, focus = false})
						end, 10)
					end
				end
			})

			local function maximize_and_preserve_tree()
				local nvim_tree_view = require("nvim-tree.view")

				vim.cmd("wincmd |")

				if nvim_tree_view.is_visible() then
					local width = nvim_tree_view.get_winnr() and nvim_tree_view.View.width
					if width then
						local current_win = vim.api.nvim_get_current_win()
						vim.cmd("NvimTreeResize " .. width)
						vim.api.nvim_set_current_win(current_win)
					end
				end

			end
			vim.keymap.set("n", "<C-w>|", maximize_and_preserve_tree, { desc = "Maximize window preserve nvim-tree" })
			vim.keymap.set("n", "<leader>tt", '<cmd>NvimTreeToggle<CR>')
			vim.keymap.set("n", "<leader>tf", '<cmd>NvimTreeFocus<CR>')
		end,
	},
}
