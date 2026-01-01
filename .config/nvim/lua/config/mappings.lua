-- Neovim mappings.

local helpers = require("config.helpers")

-- Clear highlighting on escape.
helpers.map("n", "<Esc>", "<Esc>:noh<CR>")

-- Map write and quit.
helpers.map("n", "<Leader>w", ":update<CR>")
helpers.map("n", "<Leader>q", ":quit<CR>")
helpers.map("n", "<Leader>Q", ":quit!<CR>")

-- Map movement keys.
helpers.map("n", "j", "h")
helpers.map("n", "k", "j")
helpers.map("n", "l", "k")
helpers.map("n", ";", "l")
helpers.map("v", "j", "h")
helpers.map("v", "k", "j")
helpers.map("v", "l", "k")
helpers.map("v", ";", "l")

-- Don't override the clipboard on delete.
helpers.map("n", "d", "\"1d")
helpers.map("n", "D", "0\"1d$")
helpers.map("n", "c", "\"1c")
helpers.map("n", "C", "0\"1c$")
helpers.map("n", "<Del>", "\"1d<Right>")
helpers.map("v", "d", "\"1d")
helpers.map("v", "D", "0\"1d$")
helpers.map("v", "c", "\"1c")
helpers.map("v", "C", "0\"1c$")
helpers.map("v", "<Del>", "\"1d<Right>")
helpers.map("x", "p", "\"_dP")

-- Keep visual highlighting after shifting.
helpers.map("v", "<", "<gv")
helpers.map("v", ">", ">gv")
