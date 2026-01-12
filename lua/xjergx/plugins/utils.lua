-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              UTILS                                       ║
-- ║                    Which-key, persistence, and utilities                 ║
-- ║    (toggleterm, spectre, zen-mode, twilight replaced by snacks.lua)      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              WHICH-KEY                                   │
  -- │                     Muestra keybindings disponibles                      │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        rules = false,
      },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>gt", group = "toggle" },
        { "<leader>h", group = "harpoon" },
        { "<leader>m", group = "markers" },
        { "<leader>mg", group = "marker groups" },
        { "<leader>q", group = "session" },
        { "<leader>s", group = "search" },
        { "<leader>sn", group = "noice" },
        { "<leader>t", group = "terminal" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader><tab>", group = "tabs" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              PERSISTENCE                                 │
  -- │                         Session management                               │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = vim.opt.sessionoptions:get(),
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              PLENARY                                     │
  -- │                 Utilidades Lua (requerido por muchos plugins)            │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              NUI                                         │
  -- │                  UI components (requerido por noice, etc)                │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              VIM-REPEAT                                  │
  -- │                   Repeat plugin commands with .                          │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              BETTER-ESCAPE                               │
  -- │                   jk/kj para salir de insert mode sin delay              │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = 300,
      mappings = {
        i = {
          j = {
            k = "<Esc>",
          },
          k = {
            j = "<Esc>",
          },
        },
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              WAKATIME                                    │
  -- │                    Time tracking para programadores                      │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
    enabled = function()
      return vim.fn.filereadable(vim.fn.expand("~/.wakatime.cfg")) == 1
    end,
  },
}
