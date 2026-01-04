-- The blink configuration file.

require("blink.cmp").setup({
    fuzzy = {
        implementation = "lua"
    },
    keymap = {
        ["<C-i>"] = { "show" },
        ["<C-k>"] = { "select_next", "fallback" },
        ["<C-l>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" }
    },
    signature = {
        enabled = true,
    }
})
