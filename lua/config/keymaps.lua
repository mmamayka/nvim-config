local map = vim.keymap.set

vim.api.nvim_set_keymap('n', '<leader> ', 'za', { noremap = true, silent = true })

-- Git manipulations

map('n', '<leader>hs', function() require('gitsigns').stage_hunk() end, {
	desc = "Git: Stage/unstage hunk under the cursor"
})

local function stage_hunk_visual()
	require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end

map('v', '<leader>hs', stage_hunk_visual, {
	desc = "Git: Stage/unstage hunk partially using visual selection"
})

map('n', '<leader>Hs', function() require('gitsigns').stage_buffer() end, {
	desc = "Git: Stage all hunks in current buffer"
})

map('n', '<leader>hr', function() require('gitsigns').reset_hunk() end, {
	desc = "Git: Reset hunk under the cursor"
})

map('n', '<leader>Hr', function() require('gitsigns').reset_buffer() end, {
	desc = "Git: Reset all hunks in current buffer"
})

local function reset_hunk_visual()
		require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end

map('v', '<leader>hr', reset_hunk_visual, {
	desc = "Git: Reset hunk partially using visual selection"
})

local function next_hunk()
	if vim.wo.diff then
		vim.cmd.normal({']c', bang = true})
	else
		require('gitsigns').nav_hunk('next')
	end
end

local function prev_hunk()
	if vim.wo.diff then
		vim.cmd.normal({'[c', bang = true})
	else
		require('gitsigns').nav_hunk('prev')
	end
end

map('n', '<leader>hn', next_hunk, {
	desc = "Git: Go to the next hunk",
})
map('n', '<leader>hp', prev_hunk, {
	desc = "Git: Go to the previos hunk"
})

map('n', '<leader>hP', function() require('gitsigns').preview_hunk() end, {
	desc = "Git: Show diff of the hunk under cursor"
})

local function blame_line()
	require('gitsigns').blame_line({ full = true, extra_opts = { '-s' }})
end

map('n', '<leader>lb', blame_line, {
	desc = "Git: blame line under cursor"
})

local function blame_buffer()
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
end

map('n', '<leader>gb', blame_buffer, {
	desc = "Git: Blame current buffer"
})

local function diff_buffer()
	local count = vim.v.count
	if count < 0 then
		return
	end

	local diff_closed = false

	local curwin = vim.api.nvim_get_current_win()
	local curbuf = vim.api.nvim_win_get_buf(curwin)
	local curbufname = vim.api.nvim_buf_get_name(curbuf)

	-- if current window is gitsigns diff window - close it
	if curbufname:match('gitsigns://') and
	   vim.api.nvim_get_option_value('diff', { win = curwin} )then
		vim.api.nvim_win_close(curwin, true)
		diff_closed = true
	end

	-- if there is a window with a diff for the current window - close it
	if not diff_closed then
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			local buf = vim.api.nvim_win_get_buf(win)
			local bufname = vim.api.nvim_buf_get_name(buf)

			if vim.api.nvim_get_option_value('diff', { win = win}) and
				bufname:match(bufname) then
				vim.api.nvim_win_close(win, true)
				diff_closed = true
				break
			end
		end
	end

	-- otherwise open diff for the current window
	if count > 0 or (count == 0 and not diff_closed) then
		local revision = count > 0 and "HEAD~" .. count or "HEAD"
		require('gitsigns').diffthis(revision)
	end
end

map('n', '<leader>gd', diff_buffer, {
	desc = "Git: Diff with optional count n (HEAD~n)"
})

map({'o', 'x'}, 'ih', '<cmd>gitsigns select_hunk<cr>', {
	desc = "git: select current hunk"
})

map({'o', 'x'}, 'ah', '<cmd>gitsigns select_hunk<cr>', {
	desc = "git: select current hunk"
})

local function populate_cbuf_hunks_to_loclist()
	require('gitsigns').setqflist(0, {
		use_location_list = true,
		nr = 0,
	})
end

local function populate_cbuf_hunks_to_qflist()
	require('gitsigns').setqflist(0)
end

local function populate_all_hunks_to_qflist()
	require('gitsigns').setqflist('all')
end

map('n', '<leader>hl', populate_cbuf_hunks_to_loclist, {
	desc = "Git: populate all hunks in current buffer to loclist"
})

map('n', '<leader>hL', populate_cbuf_hunks_to_qflist, {
	desc = "Git: populate all hunks in current buffer to quick fix list"
})

map('n', '<leader>HL', populate_all_hunks_to_qflist, {
	desc = "Git: populate all hunks to quick fix list"
})
