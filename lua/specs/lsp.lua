return {
	{
		'neovim/nvim-lspconfig',
		version = '*',
	},
	{
		'mason-org/mason.nvim',
		version = '*',
		lazy=false,
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		}
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"pyright",
					"bashls",
					"docker_language_server",
					"lua_ls",
				},
				automatic_enable = true,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
					},
				},
			})

			vim.lsp.config("clangd", {
				cmd = { "clangd", "--background-index", "--clang-tidy" },
			})

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.supports_method('textDocument/inlayHint') then
						vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
					end
				end,
			})
		end,
	}
}

