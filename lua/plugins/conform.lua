return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		-- Define formatters by filetype
		formatters_by_ft = {
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },
			python = { "black" },
			lua = { "stylua" },
			cs = { "csharpier" },
		},
		-- Format on save (optional)
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
	init = function()
		-- Install formatters via Mason
		local mason_registry = require("mason-registry")
		local formatters = { "prettier", "black", "stylua" }

		for _, formatter in ipairs(formatters) do
			if not mason_registry.is_installed(formatter) then
				vim.cmd("MasonInstall " .. formatter)
			end
		end
	end,
}
