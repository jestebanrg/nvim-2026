-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              XJERGX NEOVIM                               ║
-- ║                     Modern Neovim Configuration                          ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Bootstrap: Cargamos todo en orden específico
-- 1. Options primero (antes de cualquier plugin)
-- 2. Lazy.nvim (package manager + plugins)
-- 3. Keymaps globales
-- 4. Autocommands

require("xjergx.core.options")
require("xjergx.core.lazy")
require("xjergx.core.keymaps")
require("xjergx.core.autocmds")
