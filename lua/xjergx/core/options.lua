-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              VIM OPTIONS                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local opt = vim.opt
local g = vim.g

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              LEADER KEYS                                 │
-- └──────────────────────────────────────────────────────────────────────────┘
g.mapleader = " "
g.maplocalleader = "\\"

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              LINE NUMBERS                                │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes" -- Siempre mostrar signcolumn para evitar saltos

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              INDENTATION                                 │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              SEARCH                                      │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.ignorecase = true
opt.smartcase = true -- Case-sensitive si usás mayúsculas
opt.hlsearch = true
opt.incsearch = true

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              UI / UX                                     │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true
opt.scrolloff = 8 -- Mantener 8 líneas de contexto arriba/abajo
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.showmode = false -- Lualine ya lo muestra
opt.showcmd = false
opt.laststatus = 2 -- Global statusline
opt.cmdheight = 0
opt.pumheight = 10 -- Máximo items en popup menu
opt.pumblend = 10 -- Transparencia del popup
opt.winblend = 10 -- Transparencia de ventanas flotantes
opt.splitbelow = true
opt.splitright = true
opt.fillchars = {
  foldopen = "▽",
  foldclose = "▷",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ", -- Sin ~ al final del buffer
}

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              EDITING                                     │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.clipboard = "unnamedplus" -- Usar clipboard del sistema
opt.mouse = "a"
opt.undofile = true -- Persistent undo
opt.undolevels = 10000
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.updatetime = 200 -- Más rápido para CursorHold events
opt.timeoutlen = 300 -- Tiempo para which-key
opt.completeopt = { "menu", "menuone", "noselect" }
opt.virtualedit = "block" -- Permite cursor donde no hay texto en visual block
opt.inccommand = "split" -- Preview de sustituciones
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep" -- Usar ripgrep para :grep

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              FOLDING                                     │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              SESSIONS                                    │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              SPELLING                                    │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.spelllang = { "en", "es" }
opt.spelloptions = "camel" -- Detecta camelCase

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              MISC                                        │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.formatoptions = "jcroqlnt" -- Ver :help fo-table
opt.conceallevel = 2

-- Disable built-in plugins que no usamos
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
