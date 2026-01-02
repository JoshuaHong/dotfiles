-- The treesitter configuration file.

local constants = require("config.constants")

require("nvim-treesitter").install(
    constants.TREESITTER_LANGUAGES
)
