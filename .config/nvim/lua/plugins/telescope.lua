-- The Telescope configuration file.

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-k>"] = "move_selection_next",
                ["<C-l>"] = "move_selection_previous"
            }
        }
    },
    pickers = {
        find_files = {
            theme = "ivy"
        },
        live_grep = {
            theme = "ivy"
        }
    }
})
