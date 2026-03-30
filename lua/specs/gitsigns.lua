return {
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			local gitsigns = require('gitsigns')
			gitsigns.setup({
				signs = {
					add          = { text = '┃' },
					change       = { text = '┃' },
					delete       = { text = '_' },
					topdelete    = { text = '‾' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signs_staged = {
					add          = { text = '┃' },
					change       = { text = '┃' },
					delete       = { text = '_' },
					topdelete    = { text = '‾' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signs_staged_enable = true,
				signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
				numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					style = 'minimal',
					relative = 'cursor',
					border = 'single',
					row = 0,
					col = 1
				},
			})

			vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk)
			vim.keymap.set('v', '<leader>hs', function()
				gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
			end)

			vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk)
			vim.keymap.set('v', '<leader>hr', function()
				gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
			end)

			vim.keymap.set('n', '<leader>hn', function()
				if vim.wo.diff then
					vim.cmd.normal({']c', bang = true})
				else
					gitsigns.nav_hunk('next')
				end
			end)
			vim.keymap.set('n', '<leader>hp', function()
				if vim.wo.diff then
					vim.cmd.normal({'[c', bang = true})
				else
					gitsigns.nav_hunk('prev')
				end
			end)


			vim.keymap.set('n', '<leader>hP', gitsigns.preview_hunk_inline)

			vim.keymap.set('n', '<leader>lb', function ()
				gitsigns.blame_line({ full = true, extra_opts = { '-s' }})
			end)

			vim.keymap.set('n', '<leader>hq', gitsigns.setqflist)

			vim.keymap.set('n', '<leader>bb', function()
				local found_blame = false
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype == 'gitsigns-blame' then
						vim.api.nvim_win_close(win, true)
						found_blame = true
						break
					end
				end
				if not found_blame then
					require('gitsigns').blame()
				end
			end)
			vim.keymap.set('n', '<leader>bs', gitsigns.stage_buffer)
			vim.keymap.set('n', '<leader>br', gitsigns.reset_buffer)

			vim.keymap.set({'o', 'x'}, 'ih', '<Cmd>Gitsigns select_hunk<CR>')
		end,
	},
}
