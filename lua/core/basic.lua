vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.colorcolumn = "100"

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

vim.opt.autoread = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

vim.opt.showmode = false

vim.opt.clipboard = "unnamedplus"

local is_wsl = false
if vim.fn.has("unix") == 1 then
	local f = io.open("/proc/version", "r")
	if f then
		local content = f:read("*a")
		f:close()
		if content:match("Microsoft") or content:match("WSL") then
			is_wsl = true
		end
	end
end

if is_wsl then
	local win32yank_path = "/mnt/c/wsl/win32yank.exe"
	local f = io.open(win32yank_path, "r")
	if f then
		f:close()
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
