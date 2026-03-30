
local function get_curbuf_location()
	local success, nvim_navic = pcall(require, 'nvim-navic')
	if success then
		return nvim_navic.get_location()
	end
end

local function curbuf_location_available()
	local success, nvim_navic = pcall(require, 'nvim-navic')
	if success then
		return nvim_navic.is_available()
	end
end

local function get_highlight_fg(group)
	local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
	local color = hl.fg or hl.bg
	return color and string.format("#%06x", color) or nil
end

local function curbuf_gitdiff_status()
	local success = pcall(require, 'gitsigns')
	local status = vim.b.gitsigns_status_dict
	if not success or not status then
		return
	end
	return status
end

local function curbuf_gitdiff_added()
	local added = curbuf_gitdiff_status().added
	if not added or added == 0 then
		return ''
	end
	return '+' .. added
end
local function curbuf_gitdiff_changed()
	local changed = curbuf_gitdiff_status().changed
	if not changed or changed == 0 then
		return ''
	end
	return '~' .. changed
end
local function curbuf_gitdiff_removed()
	local removed = curbuf_gitdiff_status().removed
	if not removed or removed == 0 then
		return ''
	end
	return '-' .. removed
end


local function curbuf_gitdiff_available()
	local success = pcall(require, 'gitsigns')
	return success
end

local lualine_winbar_config = {
	lualine_a = {
		'filename'
	},
	lualine_b = {
		{
			'diagnostics',
		},
	},
	lualine_c = {
		{
			get_curbuf_location,
			cond = curbuf_location_available
		}
	},
	lualine_x = {
		{
			curbuf_gitdiff_added,
			cond = curbuf_gitdiff_available,
			color = function() return { fg = get_highlight_fg('GitSignsAdd') } end,
			separator = '',
		},
		{
			curbuf_gitdiff_changed,
			cond = curbuf_gitdiff_available,
			color = function() return { fg = get_highlight_fg('GitSignsChange') } end,
			separator = '',
		},
		{
			curbuf_gitdiff_removed,
			cond = curbuf_gitdiff_available,
			color = function() return { fg = get_highlight_fg('GitSignsDelete') } end,
		},
	},
	lualine_y = {
		{
			'lsp_status',
			show_name = true,
		},
		{
			'filetype',
		},
	},
	lualine_z = {
		'location',
	},
}

local lualine_config = {
	extensions = {
	},
	options = {
		theme = 'gruvbox',
		disabled_filetypes = {
			winbar = {
				'NvimTree',
				'aerial',
				'trouble',
				'gitsigns-blame',
				'git',
			},
		},
	},
	sections = {
		lualine_a = {
			'mode'
		},
		lualine_b = {
			'branch'
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {
			{
				require('lazy.status').updates,
				cond = require('lazy.status').has_updates,
			},
		},
	},
	winbar = lualine_winbar_config,
	inactive_winbar = lualine_winbar_config,
}

return {
	{
		'SmiteshP/nvim-navic',
		dependencies = {
			'neovim/nvim-lspconfig',
		},

		config = function()
			local opts = {}
			require('nvim-navic').setup(opts)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, args.buf)
					end
				end,
			})
		end
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'folke/lazy.nvim',
		},
		config = function()
			require('lualine').setup(lualine_config)
		end,
	},
}
