return {
	"Saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	options = {
		comletion = {
			crates = {
				enabled = true,
			},
		},
		lsp = {
			enabled = true,
			actions = true,
			comletion = true,
			hover = true,
		},
	},
}
