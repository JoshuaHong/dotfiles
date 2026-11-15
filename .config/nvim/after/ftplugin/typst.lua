-- The Typst configuration file.

local constants = require("config.constants")

-- Open the generated PDF on startup.
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Open Typst PDF on enter",
        { clear = true }),
    callback = function()
        local pdf = vim.fn.expand('%:p'):gsub("%.typ$", ".pdf")
        if vim.fn.filereadable(pdf) == 1 then
            vim.fn.jobstart({ constants.PDF_VIEWER, pdf })
        end
    end
})

-- Open the generated PDF on save if not already open.
vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("Open Typst PDF on save",
        { clear = true }),
    callback = function()
        local pdf = vim.fn.expand('%:p'):gsub("%.typ$", ".pdf")
        local isOpen = #vim.fn.system(
            "pgrep -f " .. vim.fn.shellescape(pdf)) > 0
        if vim.fn.filereadable(pdf) == 1 and not isOpen then
            vim.fn.jobstart({ constants.PDF_VIEWER, pdf })
        end
    end
})
