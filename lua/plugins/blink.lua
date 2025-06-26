return {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
        "rafamadriz/friendly-snippets"
    },
    event = "VeryLazy",
    opts = {
        completion = {
            documentation = {
              auto_show = true
            }
        },
        keymap = {
            preset = "super-tab"
        },
        sources = {
            default = { "path", "buffer", "snippets", "lsp" },
        },
        cmdline = {
            sources = function ()
                local cmdtype = vim.fn.getcmdtype()
                if cmdtype == "/" then
                    return { "buffer" }
                elseif cmdtype == ":" then
                    return { "cmdline" }
                else
                    return {}
                end
            end,
            keymap = {
                preset = "super-tab"
            },
            completion = {
                menu = {
                    auto_show = true
                },
            },
        },
    },
}
