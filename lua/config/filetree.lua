local nvim_tree = require("nvim-tree")

nvim_tree.setup({
	git = { enable = false },
	view = {
		side = "left",
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})

vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
