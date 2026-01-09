-- Neovim options.

-- Set diagnostics.
vim.diagnostic.config({
    float = { focusable = false },
    virtual_text = true
})
-- Set the leader key.
vim.g.mapleader = " "
-- Set the local leader key.
vim.g.maplocalleader = " "
-- Display the break indent.
vim.opt.breakindent = true
-- Set the break indent options.
vim.opt.breakindentopt = { "shift:8", "sbr" }
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
-- Set the break indent character.
vim.opt.showbreak = "↳"
-- Use case-sensitive search for capital letters.
vim.opt.smartcase = true
-- Set the number of columns a tab character uses.
vim.opt.tabstop = 4
-- Set the maximum line length.
vim.opt.textwidth = 80
-- Set the update time for the cursor hold event.
vim.opt.updatetime = 250
-- Set the floating window border.
vim.opt.winborder = "rounded"
