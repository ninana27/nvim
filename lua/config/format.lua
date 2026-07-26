local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		rust = { "rustfmt" },
	},
	format_on_save = false,
})

vim.keymap.set("n", "<leader>f", function()
	conform.format({ async = true, lsp_fallback = true })
end, { silent = true, desc = "Format buffer" })
