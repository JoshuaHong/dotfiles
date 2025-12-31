-- The treesitter configuration file.

function getTreesitterLanguages()
    return "bash", "latex", "lua", "markdown", "markdown_inline"
end

return {{
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require'nvim-treesitter'.install {
            getTreesitterLanguages()
        }
    end,
}}
