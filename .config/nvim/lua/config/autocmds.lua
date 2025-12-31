-- Neovim autocommands.

require("plugins.treesitter")

-- Automatically update lazy.nvim plugins when there are updates.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup('lazy_autoupdate', { clear = true }),
    callback = function()
        if require("lazy.status").has_updates then
            require("lazy").update({ show = false, })
        end
    end,
})

-- Enable treesitter features for specified filetypes.
vim.api.nvim_create_autocmd('FileType', {
    pattern = { getTreesitterLanguages() },
    callback = function()
        -- Enable highlighting.
        vim.treesitter.start()
        -- Enable folds.
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        -- Open all folds by default.
        vim.cmd("normal zR")
        -- Enable indentation.
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
