-- The blink configuration file.

require("blink.cmp").setup({
    fuzzy = {
        implementation = "lua"
    },
    keymap = {
        preset = "none",
        ["<C-i>"] = { "show", "fallback", },
        ["<C-k>"] = { "select_next", "fallback" },
        ["<C-l>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_and_accept", "snippet_backward", "fallback" }
    },
    signature = {
        enabled = true
    },
    completion = {
        ghost_text = {
            enabled = true
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = true
            }
        }
    }
})
