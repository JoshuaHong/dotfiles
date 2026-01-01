-- Neovim autocommands.

require("config.helpers")

-- Update all plugins on startup.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Update plugins", { clear = true }),
    callback = function()
        vim.pack.update({}, {force = "true"})
        pcall(vim.cmd, 'TSUpdate')
    end
})

-- Enable treesitter features for specified filetypes.
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup("Enable treesitter", { clear = true }),
    pattern = { getTreesitterLanguages() },
    callback = function()
        -- Enable highlighting.
        vim.treesitter.start()
        -- Enable indentation.
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
})

-- Show diagnostics on hover.
vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    group = vim.api.nvim_create_augroup("Show diagnostics", { clear = true }),
    callback = function()
        vim.diagnostic.open_float({}, { focus = false })
    end
})

-- Compile LaTeX files on save.
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { "*.tex" },
    group = vim.api.nvim_create_augroup("Compile LaTeX", { clear = true }),
    callback = function()
        local filename = vim.fn.expand("%")
        vim.fn.system("latexmk -pdf " .. filename ..
                " && latexmk -c " .. filename)
    end
})
