-- Neovim mappings.

local gitsigns = require("gitsigns")
local neoscroll = require("neoscroll")
local telescope = require("telescope.builtin")
local telescopeUtils = require("telescope.utils")
local tree = require("nvim-tree.api").tree
local treeUtils = require("nvim-tree.utils")

-- Clear highlighting on escape.
vim.keymap.set("n", "<Esc>", "<Esc>:noh<CR>", { silent = true })

-- Map write and quit.
vim.keymap.set("n", "<C-w>", ":update<CR>")
vim.keymap.set("n", "<CS-w>", ":wall<CR>")
vim.keymap.set("n", "<C-q>", function()
    local hasUnsavedBuffers = pcall(vim.cmd, "bmodified 1")
    if hasUnsavedBuffers then
        vim.notify("No write since last change for buffer: \"" ..
            vim.fn.fnamemodify(vim.api.nvim_buf_get_name(
                vim.api.nvim_get_current_buf()), ":t") .. "\"\n",
            vim.log.levels.ERROR)
    else
        vim.cmd("quit")
        if treeUtils.is_nvim_tree_buf() then
            vim.cmd("quit")
        end
    end
end)
vim.keymap.set("n", "<CS-q>", ":qall!<CR>")

-- Map buffer movement keys.
vim.keymap.set("n", "<C-e>", ":wincmd w<CR>")
vim.keymap.set("n", "<CS-e>", ":wincmd W<CR>")
vim.keymap.set("n", "<C-tab>", ":tabnext<CR>")
vim.keymap.set("n", "<CS-tab>", ":tabprev<CR>")

-- Map page scrolling keys.
vim.keymap.set("n", "<C-k>", function()
    neoscroll.scroll(vim.wo.scroll, { duration = 300 })
end)
vim.keymap.set("n", "<C-l>", function()
    neoscroll.scroll(-vim.wo.scroll, { duration = 300 })
end)

-- Don't override the clipboard on delete.
vim.keymap.set("n", "d", "\"1d")
vim.keymap.set("n", "D", "0\"1d$")
vim.keymap.set("n", "c", "\"1c")
vim.keymap.set("n", "C", "0\"1c$")
vim.keymap.set("n", "<Del>", "\"1d<Right>")
vim.keymap.set("v", "d", "\"1d")
vim.keymap.set("v", "D", "0\"1d$")
vim.keymap.set("v", "c", "\"1c")
vim.keymap.set("v", "C", "0\"1c$")
vim.keymap.set("v", "<Del>", "\"1d<Right>")
vim.keymap.set("x", "p", "\"_dP")

-- Keep visual highlighting after shifting.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Toggle commenting the selected text.
vim.keymap.set("n", "<CS-/>", "gcc", { remap = true })
vim.keymap.set("v", "<CS-/>", "gc", { remap = true })

-- Telescope key mappings.
vim.keymap.set("n", "<C-f>", function()
    telescope.find_files({ cwd = telescopeUtils.buffer_dir() })
end)
vim.keymap.set("n", "<C-s>", function()
    telescope.live_grep({ cwd = telescopeUtils.buffer_dir() })
end)
vim.keymap.set("n", "<C-b>", telescope.buffers)
vim.keymap.set("n", "<C-i>", telescope.marks)
vim.keymap.set("n", "<C-g>", telescope.git_status)
vim.keymap.set("n", "<C-a>", telescope.lsp_references)
vim.keymap.set("n", "<C-d>", telescope.lsp_definitions)

-- Gitsigns key mappings.
vim.keymap.set("n", "<C-h>", function()
    gitsigns.nav_hunk("next")
    vim.defer_fn(function()
        gitsigns.preview_hunk_inline()
    end, 10)
end)
vim.keymap.set("n", "<CS-h>", function()
    gitsigns.nav_hunk("prev")
    vim.defer_fn(function()
        gitsigns.preview_hunk_inline()
    end, 10)
end)
vim.keymap.set("n", "<CS-r>", gitsigns.reset_hunk)
vim.keymap.set("n", "<C-o>", gitsigns.diffthis)
vim.keymap.set("n", "<C-p>", gitsigns.blame)

-- Tree key mappings.
vim.keymap.set("n", "<C-t>", function()
    tree.toggle { focus = false }
end)

-- Jump to the next diagnostic message.
vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_next)
vim.keymap.set("n", "<CS-n>", vim.diagnostic.goto_prev)
