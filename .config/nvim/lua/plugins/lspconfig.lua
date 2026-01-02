-- The lspconfig configuration file.

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                -- Recognize "vim" as a global variable.
                globals = { "vim" }
            }
        }
    }
})

vim.lsp.config("texlab", {
    settings = {
        texlab = {
            latexFormatter = "latexindent",
            latexindent = {
                -- Set the latexindent configuration file.
                ["local"] = "/home/josh/.config/latexindent/config.yaml",
                modifyLineBreaks = true
            },
        },
    },
})
