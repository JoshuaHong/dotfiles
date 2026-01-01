-- Neovim helper functions.

local helpers = {}

-- Map vim commands.
function helpers.map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, {
        noremap = true, silent = true
    })
end

return helpers
