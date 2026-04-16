-- The Man configuration file.

local treeApi = require("nvim-tree.api").tree

-- Close the tree on startup.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Close nvim-tree", { clear = true }),
    callback = function()
        treeApi.toggle()
    end
})
