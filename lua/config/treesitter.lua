local treesitter = require("nvim-treesitter")

if vim.fn.executable("tree-sitter") == 1 then
	treesitter.install({ "c", "cpp", "lua", "rust" })
else
	vim.notify("Treesitter parser installation requires the tree-sitter CLI", vim.log.levels.WARN)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "lua", "rust" },
	callback = function(args)
		vim.treesitter.start(args.buf)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
