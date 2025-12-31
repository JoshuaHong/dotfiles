-- The mason-tool-installer configuration file.

require("mason-tool-installer").setup {
    ensure_installed = {
        "lua_ls"
    },
    auto_update = true
}
