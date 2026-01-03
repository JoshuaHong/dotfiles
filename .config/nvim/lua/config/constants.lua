-- Neovim constants.

local constants = {}

-- The list of treesitter languages.
constants.TREESITTER_LANGUAGES = {
    "bash",
    "lua",
    "markdown",
    "markdown_inline",
    "typst"
}

-- The list of LSPs.
constants.LSPS = {
    "lua_ls",
    "tinymist"
}

return constants
