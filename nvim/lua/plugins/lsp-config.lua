return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "pyright", "sqlls", "omnisharp", "clangd" },
			})
		end,
	},

	{
		"Hoffs/omnisharp-extended-lsp.nvim",
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

			lspconfig.sqls.setup({
				capabilities = capabilities,
			})

			lspconfig.omnisharp.setup({
				capabilities = capabilities,
				cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },
				root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "*.cs", "omnisharp.json", "function.json"),
				settings = {
					FormattingOptions = {
						EnableEditorConfigSupport = true,
						OrganizeImports = nil,
					},
					MsBuild = {
						LoadProjectsOnDemand = nil,
					},
					RoslynExtensionsOptions = {
                        EnableDecompilationSupport = true,
						EnableAnalyzersSupport = nil,
						EnableImportCompletion = nil,
						AnalyzeOpenDocumentsOnly = nil,
					},
					Sdk = {
						IncludePrereleases = true,
					},
				},
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			omnisharp_extended = require("omnisharp_extended")
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", omnisharp_extended.lsp_definition, {})
			vim.keymap.set("n", "<leader>gi", omnisharp_extended.lsp_implementation, {})
			vim.keymap.set("n", "<leader>gr", omnisharp_extended.lsp_references, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
