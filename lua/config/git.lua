local gitsigns = require("gitsigns")

gitsigns.setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

local map = vim.keymap.set
map("n", "]h", function()
	gitsigns.nav_hunk("next")
end, { desc = "Next Git hunk" })
map("n", "[h", function()
	gitsigns.nav_hunk("prev")
end, { desc = "Previous Git hunk" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
map("n", "<leader>gb", gitsigns.blame_line, { desc = "Git blame current line" })
