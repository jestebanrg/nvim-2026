-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              AUTOCOMMANDS                                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function augroup(name)
  return vim.api.nvim_create_augroup("xjergx_" .. name, { clear = true })
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         HIGHLIGHT ON YANK                                │
-- └──────────────────────────────────────────────────────────────────────────┘
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         RESIZE SPLITS                                    │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Resize splits si la ventana cambia de tamaño
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         CLOSE WITH Q                                     │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Cerrar ciertos filetypes con 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "lspinfo",
    "notify",
    "qf",
    "query",
    "startuptime",
    "checkhealth",
    "man",
    "fugitive",
    "git",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
    "spectre_panel",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         WRAP AND SPELL                                   │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Activar wrap y spell en ciertos filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         AUTO CREATE DIRS                                 │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Crear directorios padre si no existen al guardar archivo
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         RESTORE CURSOR                                   │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Volver a la última posición del cursor al abrir archivo
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].restored_cursor then
      return
    end
    vim.b[buf].restored_cursor = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         CHECK FOR EXTERNAL CHANGES                       │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Checkear si archivos fueron modificados externamente
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         LARGE FILE HANDLING                              │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Desactivar features pesados en archivos grandes
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file"),
  callback = function(event)
    local file = event.match
    local size = vim.fn.getfsize(file)
    -- 1.5MB threshold
    if size > 1.5 * 1024 * 1024 then
      vim.b[event.buf].large_file = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.syntax = "off"
    end
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         JSON/JSONC COMMENTS                              │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Setear jsonc para archivos de config comunes
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("json_as_jsonc"),
  pattern = {
    "tsconfig.json",
    "tsconfig.*.json",
    "jsconfig.json",
    "jsconfig.*.json",
    ".eslintrc.json",
    ".prettierrc.json",
  },
  callback = function()
    vim.bo.filetype = "jsonc"
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         TERMINAL OPTIONS                                 │
-- └──────────────────────────────────────────────────────────────────────────┘
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_options"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})
