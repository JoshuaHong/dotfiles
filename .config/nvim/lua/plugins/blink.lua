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
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" }
    },
    signature = {
        enabled = true
    },
    completion = {
        ghost_text = {
            enabled = true
        }
    }
})
