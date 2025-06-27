return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 25,
		open_mapping = [[<C-\>]],
		start_in_insert = true,
		insert_mappings = true,
		terminal_mapping = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = function()
			local sysname = vim.loop.os_uname().sysname
			if sysname == "Windows_NT" then
				return "pwsh"
			elseif sysname == "Linux" then
				return os.getenv("SHELL")
			else
				return ""
			end
		end,
		auto_scroll = true,
	},
}
