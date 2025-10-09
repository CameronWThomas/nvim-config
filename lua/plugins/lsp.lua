-- plugins/lsp.lua
return {
	-- Mason: LSP server installer
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason-LSPConfig: Bridge between Mason and LSPConfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				-- Automatically install these LSP servers (use LSPConfig names, not Mason names)
				ensure_installed = {
					"ts_ls", -- TypeScript/JavaScript (was typescript-language-server)
					"tailwindcss", -- Tailwind CSS (was tailwindcss-language-server)
					-- "eslint",   -- ESLint (commented out - only enable if you have eslint installed in your project)

					-- Python LSP servers (choose one):
					--"pylsp",       -- Python LSP Server (most popular, good all-around)
					"pyright", -- Microsoft's Python LSP (faster, better type checking)
					-- "ruff_lsp", -- Ultra-fast linting/formatting (can use with pylsp/pyright)

					-- C# LSP server:
					"omnisharp", -- OmniSharp for C# development
				},
			})
		end,
	},

	-- LSPConfig: Configure the LSP servers
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			local lspconfig = require("lspconfig")

			-- TypeScript server setup (handles JS/TS/JSX/TSX)
			-- lspconfig.ts_ls.setup({
			-- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			-- })

			-- Tailwind CSS server (optional)
			-- lspconfig.tailwindcss.setup({
			--   filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
			-- })

			-- ESLint server (only works if eslint is installed in your project)
			-- Uncomment this block only if you have eslint installed
			-- lspconfig.eslint.setup({
			--   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			--   settings = {
			--     workingDirectory = { mode = "location" },
			--   },
			--   on_attach = function(client, bufnr)
			--     -- Auto-fix on save (optional)
			--     vim.api.nvim_create_autocmd("BufWritePre", {
			--       buffer = bufnr,
			--       command = "EslintFixAll",
			--     })
			--   end,
			-- })

			-- Python LSP setup (choose one approach)

			-- Option 1: Python LSP Server (most popular)
			-- lspconfig.pylsp.setup({
			--   settings = {
			--     pylsp = {
			--       plugins = {
			--         pycodestyle = { enabled = false }, -- Disable if you want to use ruff
			--         pylint = { enabled = false },      -- Disable if you want to use ruff
			--         flake8 = { enabled = false },      -- Disable if you want to use ruff
			--       }
			--     }
			--   }
			-- })

			-- Option 2: Pyright (Microsoft's Python LSP - uncomment to use instead)
			-- lspconfig.pyright.setup({
			--   settings = {
			--     python = {
			--       analysis = {
			--         typeCheckingMode = "basic", -- or "strict"
			--       }
			--     }
			--   }
			-- })

			-- C# LSP setup
			-- lspconfig.omnisharp.setup({
			--   cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			--   filetypes = { "cs", "vb" },
			--   root_dir = function(fname)
			--     return lspconfig.util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json")(fname)
			--   end,
			-- })

			-- Key mappings for LSP functions (only when LSP is attached)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					-- LSP keymaps
					vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to definition" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Show references
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Hover documentation
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show diagnostics
				end,
			})

			-- Configure diagnostic signs (error/warning icons in gutter)
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},

	-- Optional: Autocompletion setup
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"hrsh7th/cmp-buffer", -- Buffer completions
			"hrsh7th/cmp-path", -- Path completions
			"L3MON4D3/LuaSnip", -- Snippet engine
			"saadparwaiz1/cmp_luasnip", -- Snippet completions
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
