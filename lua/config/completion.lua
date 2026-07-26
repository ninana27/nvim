local blink = require("blink.cmp")

blink.build():pwait()

blink.setup({
	keymap = { preset = "super-tab" },
	appearance = { nerd_font_variant = "mono" },
	completion = { documentation = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer" } },
})
