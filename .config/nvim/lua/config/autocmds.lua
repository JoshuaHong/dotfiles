-- Neovim autocommands.

local constants = require("config.constants")
local tree = require("nvim-tree.utils")

-- Update all plugins and open the tree on startup.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Update plugins", { clear = true }),
    callback = function()
        vim.pack.update({}, { force = "true" })
        pcall(vim.cmd, "TSUpdate")
        require("nvim-tree.api").tree.toggle({ focus = false })
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

-- Exit Neovim if the tree is the last buffer remaining.
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("Exit Neovim", { clear = true }),
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and tree.is_nvim_tree_buf() then
            vim.cmd "quit"
        end
    end
})
