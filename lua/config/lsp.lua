local capabilities = require("blink.cmp").get_lsp_capabilities()

local function executable(name, fallback)
	local path = vim.fn.exepath(name)
	if path ~= "" then
		return path
	end
	if fallback and vim.fn.executable(fallback) == 1 then
		return fallback
	end
	return name
end

local lua_ls = executable("lua-language-server", "/opt/lua-language-server/bin/lua-language-server")
local lua_ls_cache = vim.fn.stdpath("cache") .. "/lua-language-server"

vim.lsp.config("lua_ls", {
	cmd = {
		lua_ls,
		"--logpath=" .. lua_ls_cache .. "/log",
		"--metapath=" .. lua_ls_cache .. "/meta",
	},
	capabilities = capabilities,
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } },
})

vim.lsp.config("clangd", {
	cmd = { executable("clangd") },
	capabilities = capabilities,
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.config("rust_analyzer", {
	cmd = { executable("rust-analyzer") },
	capabilities = capabilities,
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	settings = { ["rust-analyzer"] = { cargo = { allFeatures = true }, check = { command = "clippy" } } },
})

local servers = { "lua_ls", "clangd", "rust_analyzer" }
vim.lsp.enable(servers)

-- Ensure files passed on the command line are covered after startup events.
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.lsp.enable(servers)
	end,
})

for _, command in ipairs({
		executable("lua-language-server", "/opt/lua-language-server/bin/lua-language-server"),
		executable("clangd"),
		executable("rust-analyzer"),
}) do
	if vim.fn.executable(command) == 0 then
		vim.notify("LSP executable not found: " .. command, vim.log.levels.WARN)
	end
end

vim.diagnostic.config({
	virtual_text = false,
	 signs = true,
	underline = true,
	float = { border = "rounded", source = "if_many" },
})

vim.api.nvim_create_user_command("LspInlayHints", function()
	if not (vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable and vim.lsp.inlay_hint.is_enabled) then
		vim.notify("Inlay hints are not supported by this Neovim version", vim.log.levels.WARN)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
	vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
	vim.notify(string.format("Inlay hints %s", enabled and "disabled" or "enabled"), vim.log.levels.INFO)
end, { desc = "Toggle LSP inlay hints for the current buffer" })

vim.api.nvim_create_user_command("LspStatus", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP client attached to the current buffer", vim.log.levels.WARN)
		return
	end

	local lines = { "LSP clients:" }
	for _, client in ipairs(clients) do
		lines[#lines + 1] = string.format("- %s [%s]", client.name, client.root_dir or "no root")
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show LSP clients for the current buffer" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
		end
		map("gd", vim.lsp.buf.definition, "LSP definition")
		map("gD", vim.lsp.buf.declaration, "LSP declaration")
		map("gi", vim.lsp.buf.implementation, "LSP implementation")
		map("gr", vim.lsp.buf.references, "LSP references")
		map("K", vim.lsp.buf.hover, "LSP hover")
		map("<leader>rn", vim.lsp.buf.rename, "LSP rename")
		map("<leader>ca", vim.lsp.buf.code_action, "LSP code action")
		map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
		map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next diagnostic")
	end,
})
