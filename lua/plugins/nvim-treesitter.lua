return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = { "c", "cpp", "cmake", "lua", "make", "toml", "rust", "ron" },
		highlight = { enable = true },
	},
}
