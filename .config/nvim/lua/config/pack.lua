-- The Pack configuration file.

vim.pack.add({
    -- To install LSP servers automatically.
    { src = "https://github.com/mason-org/mason.nvim" },
    -- To enable LSP servers automatically.
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    -- To install LSP tools such as formatters and linters automatically.
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    -- To add a colorscheme.
    { src = "https://github.com/catppuccin/nvim" },
    -- To use the latest LSP configuration files automatically.
    { src = "https://github.com/neovim/nvim-lspconfig" },
    -- To use treesitter.
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" }
})

require("plugins.catppuccin")
require("plugins.lspconfig")
require("plugins.mason")
require("plugins.mason-lspconfig")
require("plugins.mason-tool-installer")
require("plugins.treesitter")
