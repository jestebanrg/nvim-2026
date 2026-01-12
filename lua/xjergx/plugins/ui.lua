-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              UI PLUGINS                                  ║
-- ║                    Colorscheme, Statusline, Noice                        ║
-- ║   (notify, dressing, indent-blankline replaced by snacks in snacks.lua)  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              KANAGAWA                                    │
  -- │                     The one true colorscheme                             │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Popup menu
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
          -- Floating windows
          NormalFloat = { bg = theme.ui.bg_m1 },
          FloatBorder = { bg = theme.ui.bg_m1 },
          FloatTitle = { bg = theme.ui.bg_m1, bold = true },
          -- Snacks picker
          SnacksPickerTitle = { fg = theme.ui.special, bold = true },
          SnacksPickerPrompt = { bg = theme.ui.bg_p1 },
          SnacksPickerBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          SnacksPickerList = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          SnacksPickerPreview = { bg = theme.ui.bg_dim },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              LUALINE                                     │
  -- │                     Statusline bonita y funcional                        │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local colors = require("kanagawa.colors").setup()
      local theme_colors = colors.theme

      return {
        options = {
          theme = "kanagawa",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
          },
        },
        sections = {
          lualine_a = {
            { "mode", separator = { left = "" }, right_padding = 2 },
          },
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
            },
          },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            {
              "filename",
              path = 1, -- Relative path
              symbols = { modified = " ", readonly = " ", unnamed = "[No Name]" },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
            },
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                  return ""
                end
                local names = {}
                for _, client in ipairs(clients) do
                  table.insert(names, client.name)
                end
                return "  " .. table.concat(names, ", ")
              end,
            },
          },
          lualine_y = {
            { "encoding", show_bomb = true },
            { "fileformat", symbols = { unix = "", dos = "", mac = "" } },
            "progress",
          },
          lualine_z = {
            { "location", separator = { right = "" }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy", "mason", "oil", "quickfix" },
      }
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              NOICE.NVIM                                  │
  -- │             Mejor UI para cmdline, messages y popupmenu                  │
  -- │      (Keeping this - more features than snacks for cmdline/LSP)         │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      routes = {
        -- Hide "written" messages and similar
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      -- Use snacks.notifier for notifications instead of noice
      notify = {
        enabled = false,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              TRANSPARENT                                 │
  -- │                     Fondo transparente en Neovim                         │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 999, -- Load after colorscheme but before other plugins
    opts = {
      groups = {
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLine",
        "CursorLineNr",
        "StatusLine",
        "StatusLineNC",
        "EndOfBuffer",
      },
      extra_groups = {
        "NormalFloat",
        "FloatBorder",
        "NvimTreeNormal",
        "NvimTreeNormalNC",
        "WhichKeyFloat",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        -- Snacks groups
        "SnacksPickerNormal",
        "SnacksPickerBorder",
        "SnacksPickerList",
        "SnacksPickerPreview",
        "SnacksNotifierNormal",
      },
      exclude_groups = {},
    },
    keys = {
      { "<leader>uT", "<Cmd>TransparentToggle<CR>", desc = "Toggle Transparency" },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              WEB DEVICONS                                │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
