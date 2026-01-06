vim.keymap.set( { "n", "i" }, "<C-z>", "<Cmd>undo<CR>", { silent = true } )

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set( "n", "<leader>wh", "<C-w>h", { silent = true } )
vim.keymap.set( "n", "<leader>wj", "<C-w>j", { silent = true } )
vim.keymap.set( "n", "<leader>wk", "<C-w>k", { silent = true } )
vim.keymap.set( "n", "<leader>wl", "<C-w>l", { silent = true } )
vim.keymap.set( "n", "<leader>ww", "<C-w>w", { silent = true } )

-- terminal
-- vim.keymap.set( "n", "<C-\\>", ":vsplit | terminal<CR>a", { silent = true } )
vim.keymap.set( "t", "<Esc>", "<C-\\><C-n>", { silent = true } )
-- vim.keymap.set( "t", "<A-b>d", "<C-\\><C-n>:bdelete!<CR>", { silent = true } )

vim.keymap.set({"i", "t"}, "<A-h>", "<Left>", { silent = true })
vim.keymap.set({"i", "t"}, "<A-l>", "<Right>", { silent = true })
vim.keymap.set({"i", "t"}, "<A-j>", "<Down>", { silent = true })
vim.keymap.set({"i", "t"}, "<A-k>", "<Up>", { silent = true })

vim.keymap.set("n", "<C-j>", "7j", { silent = true })
vim.keymap.set("n", "<C-k>", "7k", { silent = true })
