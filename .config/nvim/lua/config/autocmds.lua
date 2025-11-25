-- Neovim autocommands.

-- Automatically update lazy.nvim plugins when there are updates.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup('lazy_autoupdate', { clear = true }),
    callback = function()
        if require("lazy.status").has_updates then
            require("lazy").update({ show = false, })
        end
    end,
})
