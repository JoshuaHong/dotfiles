-- The telescope configuration file.

local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<Esc>"] = actions.close,
                ["<C-k>"] = "move_selection_next",
                ["<C-l>"] = "move_selection_previous",
                ["<C-d>"] = actions.delete_buffer
            }
        }
    },
    pickers = {
        buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            theme = "ivy"
        },
        find_files = {
            theme = "ivy"
        },
        live_grep = {
            theme = "ivy"
        }
    }
})
