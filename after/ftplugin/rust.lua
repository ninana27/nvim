local bufnr = vim.api.nvim_get_current_buf()

vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.textwidth = 100
vim.bo.formatoptions = "tcqj"

vim.wo.signcolumn = "yes"
vim.wo.number = true
vim.wo.relativenumber = true

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, buffer = bufnr })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { silent = true, buffer = bufnr })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { silent = true, buffer = bufnr })
vim.keymap.set("n", "gdd", vim.lsp.buf.declaration, { silent = true, buffer = bufnr })
vim.keymap.set("n", "<leader>;", "<C-o>", { silent = true, buffer = bufnr })

vim.keymap.set("n", "<leader>a", function()
	vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "K", function()
	vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "<leader>rr", function()
	vim.cmd.RustLsp("reloadWorkspace")
end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "<leader>ee", function()
	vim.cmd.RustLsp("explainError")
end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "<leader>rd", function()
	vim.cmd.RustLsp("renderDiagnostic")
end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "<leader>th", function()
	local enabled = vim.b[bufnr].inlay_hints_enabled or false
	vim.b[bufnr].inlay_hints_enabled = not enabled
	vim.lsp.inlay_hint.enable(not enabled)
end, { silent = true, buffer = bufnr, desc = "Toggle inlat hints" })
