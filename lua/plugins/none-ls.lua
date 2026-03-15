return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	opts = {},
	config = function()
		local registry = require("mason-registry")

		local function install(name)
			local success, package = pcall(registry.get_package, name)
			if success and not package:is_installed() then
				package:install()
			end
		end

		install("stylua")
		install("clang-format")

		local null_ls = require("null-ls")
		local sources = {
			null_ls.builtins.formatting.stylua,
		}

		if vim.fn.executable("clang-format") == 1 then
			table.insert(sources, null_ls.builtins.formatting.clang_format.with({
				filetypes = { "c", "cpp", "objc", "objcpp" },
			}))
		end

		null_ls.setup({
			sources = sources,
		})
	end,
	keys = {
		{ "<leader>lf", vim.lsp.buf.format },
	},
}
