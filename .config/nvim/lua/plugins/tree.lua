-- The tree configuration file.

local treeApi = require("nvim-tree.api")

require("nvim-tree").setup({
    on_attach = function(bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "<C-e>", ":wincmd w<CR>", opts)
        vim.keymap.set("n", "<CR>", treeApi.node.open.edit, opts)
        vim.keymap.set("n", "<C-n>", treeApi.tree.change_root_to_node, opts)
        vim.keymap.set("n", "<C-r>", treeApi.fs.rename_sub, opts)
        vim.keymap.set("n", "C-t>", treeApi.node.open.tab_drop, opts)
        vim.keymap.set("n", "<C-v>", treeApi.node.open.vertical, opts)
        vim.keymap.set("n", "<C-x>", treeApi.node.open.horizontal, opts)
        vim.keymap.set("n", "<C-d>", treeApi.fs.remove, opts)
        vim.keymap.set("n", "<C-i>", treeApi.fs.create, opts)
        vim.keymap.set("n", "<C-y>", treeApi.fs.copy.node, opts)
        vim.keymap.set("n", "<C-p>", treeApi.fs.paste, opts)
        vim.keymap.set("n", "<C-a>", treeApi.fs.copy.absolute_path, opts)
    end
})
