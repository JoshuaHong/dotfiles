-- Neovim constants.

local constants = {}

-- The list of treesitter languages.
constants.TREESITTER_LANGUAGES = {
    "bash",
    "latex",
    "lua",
    "markdown",
    "markdown_inline"
}

-- The list of LSPs.
constants.LSPS = {
    "lua_ls",
    "texlab"
}

return constants
