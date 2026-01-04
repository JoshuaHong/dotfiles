-- Neovim constants.

local constants = {}

-- The list of Treesitter languages.
constants.TREESITTER_LANGUAGES = {
    "bash",
    "lua",
    "markdown",
    "markdown_inline",
    "typst"
}

-- The list of Mason packages.
constants.MASON_PACKAGES = {
    "bashls",
    "lua_ls",
    "marksman",
    "shellcheck",
    "tinymist"
}

return constants
