-- The Pack configuration file.

vim.pack.add({
    { src = "https://github.com/catppuccin/nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("plugins.catppuccin")
require("plugins.treesitter")
