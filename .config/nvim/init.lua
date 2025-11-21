-- The Neovim configuration file.

require("helpers")

-- Use the system clipboard by default.
vim.opt.clipboard = "unnamedplus"
-- Set the column to be highlighted.
vim.opt.colorcolumn = "81"
-- Use spaces instead of tabs.
vim.opt.expandtab = true
-- Allow case-insensitive search.
vim.opt.ignorecase = true
-- Display the following hidden characters.
vim.opt.list = true
-- Set the list of hidden characters.
vim.opt.listchars = "nbsp:˽,tab:>-,trail:·"
-- Show the line numbers.
vim.opt.number = true
-- Set the number of spaces per tab.
vim.opt.shiftwidth = 4
-- Use case-sensitive search for capital letters.
vim.opt.smartcase = true
-- Set the number of columns a tab character uses.
vim.opt.tabstop = 4

-- Set the leader key.
vim.g.mapleader = " "

-- Clear highlighting on escape.
map("n", "<Esc>", "<Esc>:noh<CR>")

-- Map write and quit.
map("n", "<Leader>w", ":update<CR>")
map("n", "<Leader>q", ":quit<CR>")
map("n", "<Leader>Q", ":quit!<CR>")

-- Map movement keys.
map("n", "j", "h")
map("n", "k", "j")
map("n", "l", "k")
map("n", ";", "l")
map("v", "j", "h")
map("v", "k", "j")
map("v", "l", "k")
map("v", ";", "l")

-- Don't override the clipboard on delete.
map("n", "d", "\"1d")
map("n", "D", "0\"1d$")
map("n", "c", "\"1c")
map("n", "C", "0\"1c$")
map("n", "<Del>", "\"1d<Right>")
map("v", "d", "\"1d")
map("v", "D", "0\"1d$")
map("v", "c", "\"1c")
map("v", "C", "0\"1c$")
map("v", "<Del>", "\"1d<Right>")
map("x", "p", "\"_dP")

-- Keep visual highlighting after shifting.
map("v", "<", "<gv")
map("v", ">", ">gv")
