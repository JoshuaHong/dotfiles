-- The Pack configuration file.

vim.pack.add({
    -- To view Git chagnes.
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    -- To install LSP servers.
    { src = "https://github.com/mason-org/mason.nvim" },
    -- To enable LSP servers automatically.
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    -- To install and update LSP packages automatically.
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    -- To add a colorscheme.
    { src = "https://github.com/catppuccin/nvim" },
    -- To use the latest LSP configuration files automatically.
    { src = "https://github.com/neovim/nvim-lspconfig" },
    -- To parse code.
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    -- To search files.
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    -- To use Telescope.
    { src = "https://github.com/nvim-lua/plenary.nvim" },
})

require("plugins.catppuccin")
require("plugins.lspconfig")
require("plugins.mason")
require("plugins.mason-lspconfig")
require("plugins.mason-tool-installer")
require("plugins.telescope")
require("plugins.treesitter")
