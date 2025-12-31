-- Neovim autocommands.

require("config.helpers")

-- Update all plugins on startup.
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.pack.update({}, {force = "true"})
        pcall(vim.cmd, 'TSUpdate')
    end
})

-- Enable treesitter features for specified filetypes.
vim.api.nvim_create_autocmd('FileType', {
    pattern = { getTreesitterLanguages() },
    callback = function()
        -- Enable highlighting.
        vim.treesitter.start()
        -- Enable indentation.
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
})
