-- The LaTeX configuration file.

-- Compile LaTeX files on save.
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { "*.tex" },
    group = vim.api.nvim_create_augroup("Compile LaTeX", { clear = true }),
    callback = function()
        local filename = vim.fn.expand("%")
        vim.fn.system("latexmk -pdf " .. filename .. " && latexmk -c " ..
                filename)
    end
})
