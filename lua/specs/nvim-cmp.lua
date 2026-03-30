return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',

			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			local opts = {
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered()
				},

				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-E>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true
								})
							end
						else
							fallback()
						end
					end),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, {'i', 's'}),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {'i', 's'}),
				}),

				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'minuet' },
					{ name = 'lazydev', group_index = 0 },
					{ name = 'aicompleter' },
				}, {
					{ name = 'buffer' },
				}),
				performance = {
					fetching_timeout = 10000,
				},

				enabled = function()
					local disabled = false
					disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
					disabled = disabled or (vim.fn.reg_recording() ~= '')
					disabled = disabled or (vim.fn.reg_executing() ~= '')
					disabled = disabled or require('cmp.config.context').in_treesitter_capture('comment')
					return not disabled
				end,
			}

			cmp.setup(opts)
			cmp.setup.filetype('gitcommit', {
				{ name = 'git' },
			}, {
				{ name = 'buffer' },
			})
		end,
	}
}
