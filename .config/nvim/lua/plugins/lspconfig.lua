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
    on_attach = function(client, bufnr)
        if not vim.g.hasFirstBufferBeenOpened then
            client:exec_cmd({
                title = "Tinymist pin main to first buffer opened",
                command = "tinymist.pinMain",
                arguments = { vim.api.nvim_buf_get_name(0) },
            }, { bufnr = bufnr })
            vim.g.hasFirstBufferBeenOpened = 1
        end
    end,
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
        formatterProseWrap = true,
        formatterPrintWidth = 80,
        formatterIndentSize = 4,
    }
})
