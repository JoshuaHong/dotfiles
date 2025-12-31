-- The treesitter configuration file.

require("config.helpers")

require('nvim-treesitter').install {
    getTreesitterLanguages()
}
