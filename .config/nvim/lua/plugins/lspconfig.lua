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

vim.lsp.config("tinymist", {
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
        formatterProseWrap = true,
        formatterPrintWidth = 80,
        formatterIndentSize = 4,
    }
})
