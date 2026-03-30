return {
	{
		'milanglacier/minuet-ai.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'Davidyz/VectorCode',
			'nvim-lualine/lualine.nvim',
		},
		enabled = false,
		config = function()

			local has_vc, vectorcode_config = pcall(require, 'vectorcode.config')
			local vectorcode_cacher = nil
			if has_vc then
				vectorcode_cacher = vectorcode_config.get_cacher_backend()
			end

			local RAG_context_window_size = 8000

			local minuet = require('minuet')
			local opts = {
				cmp = {
					enable_auto_complete = true,
				},
				lsp = {
					completion = {
						enable = false,
					},
				},
				provider = 'openai_fim_compatible',
				n_completions = 3,
				context_window = 512,
				provider_options = {
					openai_fim_compatible = {
						name = 'Ollama',
						end_point = 'http://localhost:11434/v1/completions',
						stream = true,
						model = 'qwen2.5-coder:7b-base-q4_0',
						api_key = 'TERM',
						optional = {
							top_p = 0.9,
							max_tokens = 56,
						},
						template = {
							prompt = function(pref, suff)
								local prompt_message = ''
								if has_vc then
									local cache_result = vectorcode_cacher.query_from_cache(0)
									for _, file in ipairs(cache_result) do
										prompt_message = prompt_message .. "<|file_sep|>" .. file.path .. "\n" .. file.document
									end
								end

								prompt_message = vim.fn.strcharpart(prompt_message, 0, RAG_context_window_size)

								prompt_message = prompt_message .. '<|fim_prefix|>' .. pref .. '<|fim_suffix|>' .. suff .. '<|fim_middle|>'
								return prompt_message
							end,
							suffix = false,
						},
					},
				},
			}
			minuet.setup(opts)
		end,
	},
}
