-- Neovim helper functions.

-- Get the list of treesitter languages.
function getTreesitterLanguages()
    return
        "bash",
        "latex",
        "lua",
        "markdown",
        "markdown_inline"
end

-- Map commands.
function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, {
        noremap = true, silent = true
    })
end
