-- Neovim helper functions.

-- Map commands.
function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, {
        noremap = true, silent = true
    })
end
