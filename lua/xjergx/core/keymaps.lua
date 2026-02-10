-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              KEYMAPS                                     ║
-- ║                        Global Key Bindings                               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local map = vim.keymap.set

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              GENERAL                                     │
-- └──────────────────────────────────────────────────────────────────────────────────┘

-- Mejor escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "kj", "<Esc>", { desc = "Exit insert mode" })

-- Guardar
map({ "n", "i", "x", "s" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "Save file" })

-- Quit
map("n", "<leader>qq", "<Cmd>qa<CR>", { desc = "Quit all" })

-- Limpiar search highlight
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              MOVEMENT                                    │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Moverse en líneas visuales (útil con wrap)
map({ "n", "x" }, "j", "v:count == 1 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 1 ? 'gk' : 'k'", { expr = true, silent = true })

-- Centrar pantalla al moverse
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              WINDOWS                                     │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Navegación entre ventanas
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize ventanas con flechas
map("n", "<C-Up>", "<Cmd>resize +3<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<Cmd>resize -1<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<Cmd>vertical resize -1<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<Cmd>vertical resize +3<CR>", { desc = "Increase window width" })

-- Splits
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>we", "<C-w>=", { desc = "Equal size splits" })
map("n", "<leader>wq", "<C-w>q", { desc = "Close window" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              BUFFERS                                     │
-- └──────────────────────────────────────────────────────────────────────────┘

map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
-- NOTE: <leader>bd, <leader>bD, <leader>bo moved to snacks.lua (snacks.bufdelete)
map("n", "[b", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<Cmd>bnext<CR>", { desc = "Next buffer" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              EDITING                                     │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Mover líneas
map("n", "<A-j>", "<Cmd>m .+2<CR>==", { desc = "Move line down", silent = true, noremap = true })
map("i", "<A-j>", "<Esc><Cmd>m .+2<CR>==gi", { desc = "Move line down", silent = true, noremap = true })
map("n", "<A-k>", "<Cmd>m .-1<CR>==", { desc = "Move line up", silent = true, noremap = true })
map("v", "<A-j>", ":m '>+2<CR>gv=gv", { desc = "Move selection down", silent = true, noremap = true })
map("v", "<A-k>", ":m '<-1<CR>gv=gv", { desc = "Move selection up", silent = true, noremap = true })
map("i", "<A-k>", "<Esc><Cmd>m .-1<CR>==gi", { desc = "Move line up", silent = true, noremap = true })

-- Mejor indentación en visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Pegar sin perder el registro
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Duplicar línea
map("n", "<leader>d", "<Cmd>t.<CR>", { desc = "Duplicate line" })

-- Add blank line
map("n", "]<Space>", "o<Esc>k", { desc = "Add blank line below" })
map("n", "[<Space>", "O<Esc>j", { desc = "Add blank line above" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              DIAGNOSTICS                                 │
-- └──────────────────────────────────────────────────────────────────────────┘

map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- LSP organize imports
map("n", "<leader>oi", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = { only = { "source.organizeImports" }, diagnostics = {} },
  })
end, { desc = "Organize imports" })

-- Toggle auto organize imports on save (vtsls/roslyn)
map("n", "<leader>uO", function()
  vim.g.lsp_auto_organize_imports = not (vim.g.lsp_auto_organize_imports == false)
  vim.g.vtsls_auto_organize_imports = vim.g.lsp_auto_organize_imports
  vim.notify(
    "lsp auto organize imports (vtsls/roslyn): " .. (vim.g.lsp_auto_organize_imports and "ON" or "OFF"),
    vim.log.levels.INFO,
    { title = "LSP" }
  )
end, { desc = "Toggle auto organize imports" })

-- Toggle auto add missing imports on save (vtsls)
map("n", "<leader>uM", function()
  vim.g.vtsls_auto_add_missing_imports = not (vim.g.vtsls_auto_add_missing_imports == false)
  vim.notify(
    "vtsls auto add missing imports: " .. (vim.g.vtsls_auto_add_missing_imports and "ON" or "OFF"),
    vim.log.levels.INFO,
    { title = "LSP" }
  )
end, { desc = "Toggle auto add missing imports" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              QUICKFIX                                    │
-- └──────────────────────────────────────────────────────────────────────────┘

map("n", "[q", "<Cmd>cprev<CR>", { desc = "Previous quickfix" })
map("n", "]q", "<Cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", "<leader>xq", "<Cmd>copen<CR>", { desc = "Open quickfix" })
map("n", "<leader>xl", "<Cmd>lopen<CR>", { desc = "Open location list" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              TABS                                        │
-- └──────────────────────────────────────────────────────────────────────────┘

map("n", "<leader><tab>n", "<Cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader><tab>q", "<Cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader><tab>l", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader><tab>h", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                              TERMINAL                                    │
-- └──────────────────────────────────────────────────────────────────────────┘

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Go to left window" })
map("t", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Go to lower window" })
map("t", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Go to upper window" })
map("t", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Go to right window" })
