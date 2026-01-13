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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "christopher-francisco/tmux-status.nvim",
    },
    event = "VeryLazy",
    config = function()
      local has_tmux_status, tmux_status = pcall(require, "tmux-status")

      local lualine_config = {
        options = {
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = false,
              path = 4,
              shorting_target = 40,
              symbols = {
                modified = "  ",
                readonly = "",
                unnamed = "",
              },
            },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = { fg = "#ff9e64" },
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = { fg = "#ff9e64" },
            },
            {
              function()
                return "  " .. require("noice").api.status.search.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.search.has()
              end,
              color = { fg = "#ff9e64" },
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        -- sections = {},
        tabline = {},
        inactive_winbar = {},
        extensions = { "oil", "lazy", "mason" },
      }

      -- Agregar tmux-status solo si está disponible
      if has_tmux_status then
        table.insert(lualine_config.sections.lualine_c, {
          tmux_status.tmux_windows,
          cond = tmux_status.show,
          padding = { left = 3 },
        })
      end

      require("lualine").setup(lualine_config)
    end,
  },
  {
    "b0o/incline.nvim",
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#44406e",
          }
        end,
      })
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = "LspAttach",
    opts = {
      picker = "snacks",
      signs = {
        quickfix = { "", { link = "DiagnosticWarning" } },
        others = { "", { link = "DiagnosticWarning" } },
        refactor = { "", { link = "DiagnosticInfo" } },
        ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
        ["refactor.extract"] = { "", { link = "DiagnosticError" } },
        ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
        ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
        ["source"] = { "", { link = "DiagnosticError" } },
        ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
        ["codeAction"] = { "", { link = "DiagnosticWarning" } },
      },
    },
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
