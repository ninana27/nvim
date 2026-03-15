local M = {}

local function is_wsl()
	return vim.fn.has("wsl") == 1
end

local function is_windows()
	return vim.loop.os_uname().sysname == "Windows_NT"
end

local function exepath(cmd)
	if vim.fn.executable(cmd) == 1 then
		return vim.fn.exepath(cmd)
	end
end

function M.detect_compiler()
	if is_wsl() then
		local mingw = exepath("x86_64-w64-mingw32-gcc")
		if mingw then
			return {
				bin = mingw,
				output_ext = ".exe",
				target = "windows",
				name = "mingw-w64",
			}
		end
	end

	for _, candidate in ipairs({ "clang", "gcc", "cc" }) do
		local compiler = exepath(candidate)
		if compiler then
			return {
				bin = compiler,
				output_ext = is_windows() and ".exe" or "",
				target = is_windows() and "windows" or "native",
				name = candidate,
			}
		end
	end
end

function M.compiler_info()
	local compiler = M.detect_compiler()
	if compiler then
		return compiler
	end

	return {
		error = "No C compiler found. Install mingw-w64 in WSL, or clang/gcc on the current system.",
	}
end

local function shellescape(path)
	return vim.fn.shellescape(path)
end

function M.build_command(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local compiler = M.detect_compiler()
	if not compiler then
		return nil, "No C compiler found. Install mingw-w64 in WSL, or clang/gcc on the current system."
	end

	local source = vim.api.nvim_buf_get_name(bufnr)
	if source == "" then
		return nil, "Current buffer has no file name."
	end

	local output_dir = vim.fs.joinpath(vim.fn.fnamemodify(source, ":h"), "build")
	vim.fn.mkdir(output_dir, "p")

	local output = vim.fs.joinpath(output_dir, vim.fn.fnamemodify(source, ":t:r") .. compiler.output_ext)
	local cmd = {
		shellescape(compiler.bin),
		"-std=c17",
		"-g",
		"-Wall",
		"-Wextra",
		shellescape(source),
		"-o",
		shellescape(output),
	}

	return table.concat(cmd, " "), output, compiler
end

function M.run_command(bufnr)
	local build_cmd, output, compiler = M.build_command(bufnr)
	if not build_cmd then
		return nil, output
	end

	local run_cmd = shellescape(output)
	if compiler.target == "windows" and is_windows() then
		run_cmd = "& " .. run_cmd
	end

	return build_cmd .. " && " .. run_cmd, output, compiler
end

function M.open_terminal(command, cwd)
	vim.cmd("botright 15split")
	vim.cmd("enew")
	vim.fn.termopen(command, {
		cwd = cwd,
	})
	vim.cmd("startinsert")
end

function M.switch_source_header()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({
		bufnr = bufnr,
		name = "clangd",
	})

	if #clients == 0 then
		vim.notify("clangd is not attached to the current buffer.", vim.log.levels.WARN)
		return
	end

	local params = {
		uri = vim.uri_from_bufnr(bufnr),
	}
	local result = vim.lsp.buf_request_sync(bufnr, "textDocument/switchSourceHeader", params, 1000)

	if not result then
		vim.notify("clangd did not return a source/header switch target.", vim.log.levels.WARN)
		return
	end

	for _, response in pairs(result) do
		local uri = response.result
		if uri and uri ~= "" then
			vim.cmd.edit(vim.uri_to_fname(uri))
			return
		end
	end

	vim.notify("No matching source/header file found.", vim.log.levels.WARN)
end

function M.build_current()
	if vim.bo.modified then
		vim.cmd("write")
	end

	local command, output, compiler = M.build_command()
	if not command then
		vim.notify(output, vim.log.levels.ERROR)
		return
	end

	M.open_terminal(command, vim.fn.expand("%:p:h"))
	vim.notify(
		string.format("Building with %s -> %s", compiler.name, vim.fn.fnamemodify(output, ":~:.")),
		vim.log.levels.INFO
	)
end

function M.run_current()
	if vim.bo.modified then
		vim.cmd("write")
	end

	local command, output, compiler = M.run_command()
	if not command then
		vim.notify(output, vim.log.levels.ERROR)
		return
	end

	M.open_terminal(command, vim.fn.expand("%:p:h"))
	vim.notify(
		string.format("Building and running with %s -> %s", compiler.name, vim.fn.fnamemodify(output, ":~:.")),
		vim.log.levels.INFO
	)
end

return M
