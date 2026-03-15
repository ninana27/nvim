local bufnr = vim.api.nvim_get_current_buf()
local c = require("core.c")

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
vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true, buffer = bufnr })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true, buffer = bufnr })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { silent = true, buffer = bufnr })
vim.keymap.set("n", "<leader>;", "<C-o>", { silent = true, buffer = bufnr })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true, buffer = bufnr, desc = "Rename symbol" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true, buffer = bufnr, desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true, buffer = bufnr, desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, { silent = true, buffer = bufnr, desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>cb", c.build_current, { silent = true, buffer = bufnr, desc = "Build current C file" })
vim.keymap.set("n", "<leader>cr", c.run_current, { silent = true, buffer = bufnr, desc = "Build and run current C file" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { silent = true, buffer = bufnr, desc = "Format current C file" })
vim.keymap.set("n", "<leader>cs", c.switch_source_header, { silent = true, buffer = bufnr, desc = "Switch source/header" })

vim.api.nvim_buf_create_user_command(bufnr, "CBuild", c.build_current, {
	desc = "Build current C file",
})

vim.api.nvim_buf_create_user_command(bufnr, "CRun", c.run_current, {
	desc = "Build and run current C file",
})

vim.api.nvim_buf_create_user_command(bufnr, "CHeader", c.switch_source_header, {
	desc = "Switch between C source and header",
})
