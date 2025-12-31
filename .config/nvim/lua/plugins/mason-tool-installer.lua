-- The mason-tool-installer configuration file.

require("mason-tool-installer").setup {
    ensure_installed = {
        "lua_ls",
        "texlab"
    },
    auto_update = true
}
