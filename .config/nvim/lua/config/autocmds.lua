-- Neovim autocommands.

local constants = require("config.constants")

-- Update all plugins on startup.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Update plugins", { clear = true }),
    callback = function()
        vim.pack.update({}, { force = "true" })
        pcall(vim.cmd, "TSUpdate")
    end
})

-- Enable treesitter features for specified filetypes.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("Enable treesitter", { clear = true }),
    pattern = constants.TREESITTER_LANGUAGES,
    callback = function()
        -- Enable highlighting.
        vim.treesitter.start()
        -- Enable indentation.
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
})

-- Show diagnostics on hover.
vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("Show diagnostics", { clear = true }),
    callback = function()
        vim.diagnostic.open_float({}, { focus = false })
    end
})

-- Format the file on save.
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("Format file", { clear = true }),
    callback = function()
        -- Set async to false to ensure the file is formatted before saving it.
        vim.lsp.buf.format { async = false }
    end,
})
