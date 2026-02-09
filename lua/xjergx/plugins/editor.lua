local parsers = {
  -- Tu stack
  "typescript",
  "javascript",
  "tsx",
  "vue",
  "c_sharp",
  "lua",
  -- Web
  "html",
  "css",
  "scss",
  "json",
  -- Config
  "yaml",
  "toml",
  -- Git
  "git_config",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "gitattributes",
  -- Docs
  "markdown",
  "markdown_inline",
  -- Scripting
  "bash",
  "regex",
  "luadoc",
  -- Misc
  "diff",
  "dockerfile",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").install(parsers)

      -- Función para activar treesitter en un buffer
      local function enable_treesitter(buf)
        -- Solo para buffers válidos con filetype
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        local ft = vim.bo[buf].filetype
        if ft == "" then
          return
        end

        local ok = pcall(vim.treesitter.start, buf)
        if ok then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      -- Autocmd para buffers FUTUROS
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
        callback = function(args)
          enable_treesitter(args.buf)
        end,
      })

      -- Activar treesitter en buffers que YA ESTÁN ABIERTOS
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          enable_treesitter(buf)
        end
      end

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │  INCREMENTAL SELECTION                                             │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.keymap.set("n", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").init_selection()
      end, { desc = "Init Treesitter Selection" })

      vim.keymap.set("x", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").node_incremental()
      end, { desc = "Increment Selection" })

      vim.keymap.set("x", "<BS>", function()
        require("nvim-treesitter.incremental_selection").node_decremental()
      end, { desc = "Decrement Selection" })
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         TREESITTER TEXTOBJECTS                           │
  -- │              Branch main para compatibilidad con nueva API               │
  -- │  https://github.com/nvim-treesitter/nvim-treesitter-textobjects         │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    {
      "nvim-treesitter/nvim-treesitter-context",
      event = "VeryLazy",
      opts = {
        enable = true,
        max_lines = 3,
        min_window_height = 20,
        multiline_threshold = 1, -- Mostrar contexto en una sola línea si es posible
        mode = "cursor", -- Mostrar contexto basado en la posición del cursor
      },
      keys = {
        {
          "<leader>ut",
          function()
            require("treesitter-context").toggle()
          end,
          desc = "Toggle Treesitter Context",
        },
        {
          "[C",
          function()
            require("treesitter-context").go_to_context()
          end,
          desc = "Go to context",
        },
      },
    },
  },
  config = function()
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")
    local select_keymaps = {
      -- Funciones
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      -- Clases
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      -- Parámetros
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      -- Loops
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      -- Condicionales
      ["ai"] = "@conditional.outer",
      ["ii"] = "@conditional.inner",
      -- Comentarios
      ["a/"] = "@comment.outer",
      -- Bloques
      ["ab"] = "@block.outer",
      ["ib"] = "@block.inner",
      -- Calls
      ["am"] = "@call.outer",
      ["im"] = "@call.inner",
    }

    for keymap, query in pairs(select_keymaps) do
      vim.keymap.set({ "x", "o" }, keymap, function()
        select.select_textobject(query, "textobjects", nil, { lookahead = true })
      end, { desc = "Select " .. query })
    end

    -- ┌──────────────────────────────────────────────────────────────────┐
    -- │  MOVE - Moverse entre text objects                              │
    -- └──────────────────────────────────────────────────────────────────┘
    local move_keymaps = {
      -- goto_next_start
      { "]f", "@function.outer", "goto_next_start", "Next function start" },
      { "]c", "@class.outer", "goto_next_start", "Next class start" },
      { "]a", "@parameter.inner", "goto_next_start", "Next parameter" },
      { "]b", "@block.outer", "goto_next_start", "Next block" },
      { "]m", "@call.outer", "goto_next_start", "Next call" },
      -- goto_next_end
      { "]F", "@function.outer", "goto_next_end", "Next function end" },
      { "]C", "@class.outer", "goto_next_end", "Next class end" },
      -- goto_previous_start
      { "[f", "@function.outer", "goto_previous_start", "Prev function start" },
      { "[c", "@class.outer", "goto_previous_start", "Prev class start" },
      { "[a", "@parameter.inner", "goto_previous_start", "Prev parameter" },
      { "[b", "@block.outer", "goto_previous_start", "Prev block" },
      { "[m", "@call.outer", "goto_previous_start", "Prev call" },
      -- goto_previous_end
      { "[F", "@function.outer", "goto_previous_end", "Prev function end" },
      { "[C", "@class.outer", "goto_previous_end", "Prev class end" },
    }

    for _, mapping in ipairs(move_keymaps) do
      local key, query, direction, desc = mapping[1], mapping[2], mapping[3], mapping[4]
      vim.keymap.set({ "n", "x", "o" }, key, function()
        move[direction](query, "textobjects")
      end, { desc = desc })
    end

    -- ┌──────────────────────────────────────────────────────────────────┐
    -- │  SWAP - Intercambiar elementos                                  │
    -- └──────────────────────────────────────────────────────────────────┘
    vim.keymap.set("n", "<leader>a", function()
      swap.swap_next("@parameter.inner", "textobjects")
    end, { desc = "Swap next parameter" })

    vim.keymap.set("n", "<leader>A", function()
      swap.swap_previous("@parameter.inner", "textobjects")
    end, { desc = "Swap prev parameter" })
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    -- ; repite hacia adelante, , repite hacia atrás (consistente)
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat last move prev" })

    -- Hacer f, F, t, T también repetibles con ; y ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                            NVIM-TS-AUTOTAG                               │
  -- │         Auto close y rename de tags HTML/Vue/JSX con Treesitter          │
  -- │           https://github.com/windwp/nvim-ts-autotag                      │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true, -- Auto close on trailing </
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              MINI.NVIM                                   │
  -- │                       Colección de utilidades                            │
  -- └──────────────────────────────────────────────────────────────────────────┘
  -- Mini.pairs - Auto close brackets
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },

  -- Mini.surround - Surround text objects
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  -- Mini.comment - Comments
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
      { "<leader>xt", "<Cmd>Trouble todo toggle<CR>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<Cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>", desc = "Todo/Fix/Fixme" },
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │  NOTE: vim-illuminate replaced by snacks.words in snacks.lua            │
  -- │  Keymaps: ]] and [[ for next/prev reference                             │
  -- └──────────────────────────────────────────────────────────────────────────┘

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              TROUBLE                                     │
  -- │                     Lista de errores y warnings                          │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      { "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics" },
      { "<leader>cs", "<Cmd>Trouble symbols toggle<CR>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<Cmd>Trouble lsp toggle<CR>", desc = "LSP References (Trouble)" },
      { "<leader>xL", "<Cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
      {
        "[x",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]x",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    opts = {
      completions = { lsp = { enabled = true } },
      heading = {
        enabled = true,
        sign = true,
        width = "full",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        left_pad = 1,
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        left_pad = 0,
        right_pad = 0,
        highlight = "RenderMarkdownBullet",
      },
      checkbox = {
        enabled = true,
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        },
        left_pad = 0,
        right_pad = 1,
        unchecked = {
          -- Replaces '[ ]' of 'task_list_marker_unchecked'.
          icon = "󰄱 ",
          -- Highlight for the unchecked icon.
          highlight = "RenderMarkdownUnchecked",
          -- Highlight for item associated with unchecked checkbox.
          scope_highlight = nil,
        },
        checked = {
          -- Replaces '[x]' of 'task_list_marker_checked'.
          icon = "󰱒 ",
          -- Highlight for the checked icon.
          highlight = "RenderMarkdownChecked",
          -- Highlight for item associated with checked checkbox.
          scope_highlight = nil,
        },
        highlight = "RenderMarkdownCheckbox",
      },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    opts = {},
    keys = {
      {
        "<leader>rs",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
  },
  {
    "romus204/referencer.nvim",
    config = function()
      require("referencer").setup()
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              OBSIDIAN.NVIM                               │
  -- │                    Integración con vaults de Obsidian                    │
  -- │               https://github.com/epwalsh/obsidian.nvim                   │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/vault/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/vault/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "vault",
          path = "~/vault",
        },
      },
      notes_subdir = "inbox",
      new_notes_location = "notes_subdir",
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "daily.md",
      },
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>nc"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      -- picker = {
      --   name = "telescope",
      -- },
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        },
      },
    },
    keys = {
      { "<leader>nn", "<Cmd>ObsidianNew<CR>", desc = "New Note" },
      { "<leader>nT", "<Cmd>ObsidianNewFromTemplate<CR>", desc = "New from Template" },
      { "<leader>ni", "<Cmd>ObsidianTemplate<CR>", desc = "Insert Template" },
      { "<leader>ns", "<Cmd>ObsidianSearch<CR>", desc = "Search Notes" },
      { "<leader>nq", "<Cmd>ObsidianQuickSwitch<CR>", desc = "Quick Switch" },
      { "<leader>nb", "<Cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
      { "<leader>nt", "<Cmd>ObsidianToday<CR>", desc = "Today's Note" },
      { "<leader>ny", "<Cmd>ObsidianYesterday<CR>", desc = "Yesterday's Note" },
      { "<leader>nl", "<Cmd>ObsidianLinks<CR>", desc = "Links in Note" },
      { "<leader>nf", "<Cmd>ObsidianFollowLink<CR>", desc = "Follow Link" },
      { "<leader>np", "<Cmd>ObsidianPasteImg<CR>", desc = "Paste Image" },
      { "<leader>nr", "<Cmd>ObsidianRename<CR>", desc = "Rename Note" },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
      {
        "<leader>sR",
        function()
          local grug = require("grug-far")
          grug.open({
            transient = true,
            prefills = {
              paths = vim.fn.expand("%"),
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace (current file)",
      },
    },
  },
  {
    "dmmulroy/tsc.nvim",
    lazy = false,
    config = function()
      require("tsc").setup({})
    end,
  },
}
