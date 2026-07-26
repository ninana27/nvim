vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 0
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect" }

-- Use the Windows clipboard when Neovim is running inside WSL.
if vim.fn.has("unix") == 1 then
	local version_file = io.open("/proc/version", "r")
	local version = version_file and version_file:read("*a") or ""
	if version_file then
		version_file:close()
	end

	if version:match("Microsoft") or version:match("WSL") then
		local win32yank_path = "/mnt/c/wsl/win32yank.exe"
		if vim.fn.filereadable(win32yank_path) == 1 then
			vim.g.clipboard = {
				name = "win32yank-wsl",
				copy = {
					["+"] = win32yank_path .. " -i --crlf",
					["*"] = win32yank_path .. " -i --crlf",
				},
				paste = {
					["+"] = win32yank_path .. " -o --lf",
					["*"] = win32yank_path .. " -o --lf",
				},
				cache_enabled = 0,
			}
		else
			vim.notify("win32yank.exe not found at " .. win32yank_path, vim.log.levels.WARN)
		end
	end
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
