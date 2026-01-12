return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              BIGFILE                                 │
      -- │              Disable features for large files                        │
      -- └──────────────────────────────────────────────────────────────────────┘
      bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              DASHBOARD                               │
      -- │                     Startup screen                                   │
      -- └──────────────────────────────────────────────────────────────────────┘
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
            },
            { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
    ██╗  ██╗     ██╗███████╗██████╗  ██████╗ ██╗  ██╗
    ╚██╗██╔╝     ██║██╔════╝██╔══██╗██╔════╝ ╚██╗██╔╝
     ╚███╔╝      ██║█████╗  ██████╔╝██║  ███╗ ╚███╔╝
     ██╔██╗ ██   ██║██╔══╝  ██╔══██╗██║   ██║ ██╔██╗
    ██╔╝ ██╗╚█████╔╝███████╗██║  ██║╚██████╔╝██╔╝ ██╗
    ╚═╝  ╚═╝ ╚════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              NOTIFIER                                │
      -- │                 Replaces nvim-notify                                 │
      -- └──────────────────────────────────────────────────────────────────────┘
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact", -- "compact" | "fancy" | "minimal"
        top_down = true,
        margin = { top = 0, right = 1, bottom = 0 },
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              QUICKFILE                               │
      -- │              Render file faster on startup                           │
      -- └──────────────────────────────────────────────────────────────────────┘
      quickfile = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              STATUSCOLUMN                            │
      -- │              Better status column with folds                         │
      -- └──────────────────────────────────────────────────────────────────────┘
      statuscolumn = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              WORDS                                   │
      -- │              Replaces vim-illuminate                                 │
      -- └──────────────────────────────────────────────────────────────────────┘
      words = {
        enabled = true,
        debounce = 200,
        notify_jump = true,
        notify_end = true,
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              INDENT                                  │
      -- │              Replaces indent-blankline                               │
      -- └──────────────────────────────────────────────────────────────────────┘
      indent = {
        enabled = true,
        indent = {
          char = "│",
          blank = " ",
        },
        scope = {
          enabled = true,
          char = "│",
          underline = false,
          only_current = false,
        },
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
        blank = {
          char = " ",
        },
        -- Exclude filetypes
        filter = function(buf)
          local exclude = {
            "help",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
            "oil",
            "snacks_dashboard",
          }
          return not vim.tbl_contains(exclude, vim.bo[buf].filetype)
        end,
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              INPUT                                   │
      -- │              Replaces dressing.nvim for vim.ui.input                 │
      -- └──────────────────────────────────────────────────────────────────────┘
      input = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              PICKER                                  │
      -- │              Replaces Telescope                                      │
      -- └──────────────────────────────────────────────────────────────────────┘
      picker = {
        enabled = true,
        sources = {
          files = {
            hidden = false,
            ignored = false,
            follow = false,
          },
          grep = {
            hidden = true,
            ignored = false,
            follow = false,
          },
          buffers = {
            current = false, -- Don't show current buffer
            sort_lastused = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<C-c>"] = { "close", mode = { "i", "n" } },
              ["<C-j>"] = { "list_down", mode = { "i", "n" } },
              ["<C-k>"] = { "list_up", mode = { "i", "n" } },
              ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
              ["<C-p>"] = { "history_back", mode = { "i", "n" } },
              ["<C-s>"] = { "edit_split", mode = { "i", "n" } },
              ["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<C-t>"] = { "edit_tab", mode = { "i", "n" } },
              ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-q>"] = { "qflist", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<C-j>"] = "list_down",
              ["<C-k>"] = "list_up",
              ["q"] = "close",
            },
          },
        },
        layout = {
          preset = "default", -- "default", "dropdown", "ivy", "select", "cursor", "float"
          preview = true,
        },
        formatters = {
          file = {
            filename_first = true,
          },
        },
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              SCOPE                                   │
      -- │              Scope detection and text objects                        │
      -- └──────────────────────────────────────────────────────────────────────┘
      scope = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              SCROLL                                  │
      -- │              Smooth scrolling                                        │
      -- └──────────────────────────────────────────────────────────────────────┘
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 150 },
          easing = "linear",
        },
        filter = function(buf)
          return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= "terminal"
        end,
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              ZEN                                     │
      -- │              Replaces zen-mode.nvim                                  │
      -- └──────────────────────────────────────────────────────────────────────┘
      zen = {
        enabled = true,
        toggles = {
          dim = true,
          git_signs = false,
          mini_diff_signs = false,
          diagnostics = false,
          inlay_hints = false,
        },
        show = {
          statusline = false,
          tabline = false,
        },
        win = { style = "zen" },
        zoom = {
          toggles = {},
          show = { statusline = true, tabline = true },
          win = {
            backdrop = false,
            width = 0,
          },
        },
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              DIM                                     │
      -- │              Replaces twilight.nvim (dim inactive code)              │
      -- └──────────────────────────────────────────────────────────────────────┘
      dim = {
        enabled = true,
        scope = {
          min_size = 5,
          max_size = 20,
          siblings = true,
        },
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              TERMINAL                                │
      -- │              Replaces toggleterm.nvim                                │
      -- └──────────────────────────────────────────────────────────────────────┘
      terminal = {
        enabled = true,
        win = {
          style = "terminal",
          position = "float",
          border = "rounded",
          height = 0.8,
          width = 0.8,
        },
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              LAZYGIT                                 │
      -- │              Built-in lazygit integration                            │
      -- └──────────────────────────────────────────────────────────────────────┘
      lazygit = {
        enabled = true,
        configure = true,
        win = {
          style = "lazygit",
        },
      },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              GIT                                     │
      -- │              Git utilities (blame, browse)                           │
      -- └──────────────────────────────────────────────────────────────────────┘
      git = { enabled = true },
      gitbrowse = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              RENAME                                  │
      -- │              LSP rename with preview                                 │
      -- └──────────────────────────────────────────────────────────────────────┘
      rename = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              BUFDELETE                               │
      -- │              Delete buffers without breaking layout                  │
      -- └──────────────────────────────────────────────────────────────────────┘
      bufdelete = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              TOGGLE                                  │
      -- │              Toggle utilities                                        │
      -- └──────────────────────────────────────────────────────────────────────┘
      toggle = { enabled = true },

      -- ┌──────────────────────────────────────────────────────────────────────┐
      -- │                              STYLES                                  │
      -- │              Custom window styles                                    │
      -- └──────────────────────────────────────────────────────────────────────┘
      styles = {
        notification = {
          wo = { wrap = true },
        },
        lazygit = {
          width = 0,
          height = 0,
        },
        zen = {
          width = 120,
          height = 0,
          backdrop = { transparent = true, blend = 40 },
        },
      },
    },

    -- ┌──────────────────────────────────────────────────────────────────────────┐
    -- │                              KEYS                                        │
    -- └──────────────────────────────────────────────────────────────────────────┘
    keys = {
      -- ═══════════════════════════════════════════════════════════════════════
      --                              PICKER (Telescope replacement)
      -- ═══════════════════════════════════════════════════════════════════════

      -- Files
      {
        "<leader><space>",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fF",
        function()
          Snacks.picker.files({ hidden = true, ignored = true })
        end,
        desc = "Find Files (All)",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.lines()
        end,
        desc = "Grep",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Word under cursor",
        mode = { "n", "x" },
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Buffers",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },

      -- Git (picker)
      {
        "<leader>gC",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Commits",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gB",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gD",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git Diff (Hunks)",
      },

      -- LSP (picker)
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "Goto Declaration",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto Type Definition",
      },

      -- Misc (picker)
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>so",
        function()
          Snacks.picker.vim_options()
        end,
        desc = "Vim Options",
      },
      {
        "<leader>sR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Document Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>sp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>s.",
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },

      -- Config files
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              TERMINAL
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<C-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },
      {
        "<C-_>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },
      {
        "<leader>tf",
        function()
          Snacks.terminal(nil, { win = { position = "float" } })
        end,
        desc = "Float Terminal",
      },
      {
        "<leader>th",
        function()
          Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
        end,
        desc = "Horizontal Terminal",
      },
      {
        "<leader>tv",
        function()
          Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
        end,
        desc = "Vertical Terminal",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              LAZYGIT
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit File History",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              GIT
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>go",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              BUFFERS
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          Snacks.bufdelete.all()
        end,
        desc = "Delete All Buffers",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete Other Buffers",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              WORDS (illuminate replacement)
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              ZEN MODE
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>Z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              NOTIFICATIONS
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>uN",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              RENAME
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              TOGGLES
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>us",
        function()
          Snacks.toggle.option("spell"):toggle()
        end,
        desc = "Toggle Spelling",
      },
      {
        "<leader>uw",
        function()
          Snacks.toggle.option("wrap"):toggle()
        end,
        desc = "Toggle Wrap",
      },
      {
        "<leader>uL",
        function()
          Snacks.toggle.option("relativenumber"):toggle()
        end,
        desc = "Toggle Relative Numbers",
      },
      {
        "<leader>ul",
        function()
          Snacks.toggle.line_number():toggle()
        end,
        desc = "Toggle Line Numbers",
      },
      {
        "<leader>ud",
        function()
          Snacks.toggle.diagnostics():toggle()
        end,
        desc = "Toggle Diagnostics",
      },
      {
        "<leader>uc",
        function()
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :toggle()
        end,
        desc = "Toggle Conceallevel",
      },
      {
        "<leader>uT",
        function()
          Snacks.toggle.treesitter():toggle()
        end,
        desc = "Toggle Treesitter",
      },
      {
        "<leader>ub",
        function()
          Snacks.toggle.option("background", { off = "light", on = "dark" }):toggle()
        end,
        desc = "Toggle Background",
      },
      {
        "<leader>uh",
        function()
          Snacks.toggle.inlay_hints():toggle()
        end,
        desc = "Toggle Inlay Hints",
      },
      {
        "<leader>uI",
        function()
          Snacks.toggle.indent():toggle()
        end,
        desc = "Toggle Indent Guides",
      },
      {
        "<leader>uD",
        function()
          Snacks.toggle.dim():toggle()
        end,
        desc = "Toggle Dim",
      },
      {
        "<leader>ua",
        function()
          Snacks.toggle.animate():toggle()
        end,
        desc = "Toggle Animations",
      },
      {
        "<leader>uS",
        function()
          Snacks.toggle.scroll():toggle()
        end,
        desc = "Toggle Smooth Scroll",
      },
      {
        "<leader>uz",
        function()
          Snacks.toggle.zen():toggle()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>uZ",
        function()
          Snacks.toggle.zoom():toggle()
        end,
        desc = "Toggle Zoom",
      },

      -- ═══════════════════════════════════════════════════════════════════════
      --                              SCRATCH
      -- ═══════════════════════════════════════════════════════════════════════
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
    },

    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (optional, remove if unwanted)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>uI")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
