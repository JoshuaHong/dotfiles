-- The mason-tool-installer configuration file.

local constants = require("config.constants")

require("mason-tool-installer").setup({
    ensure_installed = constants.LSPS,
    auto_update = true
})
