return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = { "lua", "toml", "rust", "ron" },
		highlight = { enable = true },
	},
}
