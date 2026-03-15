return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local util = require("lspconfig.util")
		local registry = require("mason-registry")

		local function is_executable(cmd)
			return vim.fn.executable(cmd) == 1
		end

		local function get_clangd_cmd()
			local cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--fallback-style=llvm",
				"--header-insertion=iwyu",
			}
			local query_drivers = {}

			if is_executable("x86_64-w64-mingw32-gcc") then
				table.insert(query_drivers, vim.fn.exepath("x86_64-w64-mingw32-gcc"))
			end
			if is_executable("x86_64-w64-mingw32-g++") then
				table.insert(query_drivers, vim.fn.exepath("x86_64-w64-mingw32-g++"))
			end

			if #query_drivers > 0 then
				table.insert(cmd, "--query-driver=" .. table.concat(query_drivers, ","))
			end

			return cmd
		end

		local function ensure_package(name)
			local success, package = pcall(registry.get_package, name)
			if success and not package:is_installed() then
				package:install()
			end
		end

		local function setup(lsp_name, config)
			config.capabilities = require("blink.cmp").get_lsp_capabilities()
			config.on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end
			vim.lsp.config(lsp_name, config)
			vim.lsp.enable(lsp_name)
		end

		local servers = {
			lua_ls = {
				mason = "lua-language-server",
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			pyright = {
				mason = "pyright",
			},
			html = {
				mason = "html-lsp",
			},
			cssls = {
				mason = "css-lsp",
			},
			ts_ls = {
				mason = "typescript-language-server",
			},
			emmet_ls = {
				mason = "emmet-ls",
			},
			clangd = {
				mason = "clangd",
				cmd = get_clangd_cmd(),
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_dir = function(bufnr, on_dir)
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					local root = util.root_pattern("compile_commands.json", "compile_flags.txt", ".clangd", ".git")(bufname)
					if root then
						on_dir(root)
						return
					end

					if bufname ~= "" then
						on_dir(vim.fs.dirname(bufname))
					end
				end,
				single_file_support = true,
			},
		}

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_enable = false,
		})

		for lsp_name, config in pairs(servers) do
			ensure_package(config.mason)
			config.mason = nil
			setup(lsp_name, config)
		end

		vim.diagnostic.config({
			update_in_insert = true,
			virtual_text = true,
		})
	end,
}
