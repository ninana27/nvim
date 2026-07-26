vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/akinsho/toggleterm.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/nvim-tree/nvim-tree.lua",
})

require("config.ui")
require("config.completion")
require("config.format")
require("config.treesitter")
require("config.terminal")
require("config.project")
require("config.git")
require("config.filetree")

require("telescope").setup({})
require("nvim-autopairs").setup({ check_ts = true })
require("nvim-surround").setup({})
