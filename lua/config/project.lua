local function project_root(markers)
	return vim.fs.root(0, markers) or vim.fn.getcwd()
end

local function run(command, markers, description)
	local terminal = require("toggleterm.terminal").Terminal:new({
		cmd = command,
		dir = project_root(markers),
		direction = "float",
		close_on_exit = false,
		display_name = description,
	})
	terminal:toggle()
end

vim.keymap.set("n", "<leader>cb", function()
	run("cargo build", { "Cargo.toml" }, "cargo build")
end, { desc = "Cargo build" })

vim.keymap.set("n", "<leader>ct", function()
	run("cargo test", { "Cargo.toml" }, "cargo test")
end, { desc = "Cargo test" })

vim.keymap.set("n", "<leader>ck", function()
	run("cargo check", { "Cargo.toml" }, "cargo check")
end, { desc = "Cargo check" })

vim.keymap.set("n", "<leader>cc", function()
	run("cmake --build build", { "CMakeLists.txt" }, "cmake build")
end, { desc = "CMake build" })
