-- Neovim mappings.

require("config.helpers")

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
