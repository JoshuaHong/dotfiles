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

-- The list of mason packages.
constants.MASON_PACKAGES = {
    "bashls",
    "lua_ls",
    "marksman",
    "shellcheck",
    "tinymist"
}

return constants
