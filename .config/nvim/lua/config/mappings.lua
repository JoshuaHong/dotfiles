-- Neovim mappings.

local gitsigns = require("gitsigns")
local telescope = require("telescope.builtin")
local treeApi = require("nvim-tree.api").tree
local treeUtils = require("nvim-tree.utils")

-- Clear highlighting on escape.
vim.keymap.set("n", "<Esc>", "<Esc>:noh<CR>", { silent = true })

-- Map write and quit.
vim.keymap.set("n", "<C-w>", ":update<CR>")
vim.keymap.set("n", "<CS-w>", ":write<CR>")
vim.keymap.set("n", "<C-q>", function()
    vim.cmd "quit"
    if #vim.api.nvim_list_wins() == 1 and treeUtils.is_nvim_tree_buf() then
        vim.cmd "quit"
    end
end)
vim.keymap.set("n", "<CS-q>", function()
    vim.cmd "qall!"
end)

-- Map movement keys.
vim.keymap.set("n", "j", "h")
vim.keymap.set("n", "k", "j")
vim.keymap.set("n", "l", "k")
vim.keymap.set("n", ";", "l")
vim.keymap.set("v", "j", "h")
vim.keymap.set("v", "k", "j")
vim.keymap.set("v", "l", "k")
vim.keymap.set("v", ";", "l")

-- Map buffer movement keys.
vim.keymap.set("n", "<C-j>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-;>", ":wincmd l<CR>")

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
vim.keymap.set("n", "<C-f>", telescope.find_files)
vim.keymap.set("n", "<C-s>", telescope.live_grep)
vim.keymap.set("n", "<C-b>", telescope.buffers)
vim.keymap.set("n", "<C-m>", telescope.marks)
vim.keymap.set("n", "<C-g>", telescope.git_status)
vim.keymap.set("n", "<C-a>", telescope.lsp_references)
vim.keymap.set("n", "<C-d>", telescope.lsp_definitions)

-- Gitsigns key mappings.
vim.keymap.set("n", "<C-h>", gitsigns.preview_hunk)
vim.keymap.set("n", "<CS-r>", gitsigns.reset_hunk)
vim.keymap.set("n", "<C-p>", gitsigns.blame)

-- Tree key mappings.
vim.keymap.set("n", "<C-t>", treeApi.change_root_to_node)
vim.keymap.set("n", "<C-Tab>", function()
    treeApi.toggle { focus = false }
end)

-- Jump to the next diagnostic message.
vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_next)
vim.keymap.set("n", "<CS-n>", vim.diagnostic.goto_prev)
