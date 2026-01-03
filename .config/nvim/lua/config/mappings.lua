-- Neovim mappings.

-- Clear highlighting on escape.
vim.keymap.set("n", "<Esc>", "<Esc>:noh<CR>", { silent = true })

-- Map write and quit.
vim.keymap.set("n", "<C-w>", ":update<CR>")
vim.keymap.set("n", "<CS-w>", ":write<CR>")
vim.keymap.set("n", "<C-q>", ":quit<CR>")
vim.keymap.set("n", "<CS-q>", ":quit!<CR>")

-- Map movement keys.
vim.keymap.set("n", "j", "h")
vim.keymap.set("n", "k", "j")
vim.keymap.set("n", "l", "k")
vim.keymap.set("n", ";", "l")
vim.keymap.set("v", "j", "h")
vim.keymap.set("v", "k", "j")
vim.keymap.set("v", "l", "k")
vim.keymap.set("v", ";", "l")

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
vim.keymap.set("n", "<C-;>", "gcc", { remap = true })
vim.keymap.set("v", "<C-;>", "gc", { remap = true })
