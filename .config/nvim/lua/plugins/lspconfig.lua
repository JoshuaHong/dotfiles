-- The lspconfig configuration file.

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim'}  -- Recognize 'vim' as a global variable
            }
        }
    }
})
