-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              EDITOR PLUGINS                              ║
-- ║          Treesitter, Autopairs, Surround, Comments, etc.                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │                         PARSERS A INSTALAR                               │
-- └──────────────────────────────────────────────────────────────────────────┘
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
  "xml",
  "http",
}

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              TREESITTER                                  │
  -- │           Neovim 0.11+ - Nueva API (NO soporta lazy loading)            │
  -- │     https://github.com/nvim-treesitter/nvim-treesitter                  │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- IMPORTANTE: main branch para la nueva API
    build = ":TSUpdate",
    lazy = false, -- NO soporta lazy loading según documentación oficial
    config = function()
      -- Instalar parsers (async por defecto)
      require("nvim-treesitter").install(parsers)

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │  HIGHLIGHTING - Usar API nativa de Neovim 0.11+                   │
      -- │  vim.treesitter.start() se llama automáticamente para filetypes   │
      -- │  que tienen parser instalado                                       │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
        callback = function(args)
          -- Solo activar si hay parser disponible para este filetype
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            -- Activar indentexpr basado en treesitter
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

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
    config = function()
      -- ┌──────────────────────────────────────────────────────────────────┐
      -- │  Nueva API Neovim 0.11+ - Cada módulo se configura por separado │
      -- └──────────────────────────────────────────────────────────────────┘
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- ┌──────────────────────────────────────────────────────────────────┐
      -- │  SELECT - Seleccionar text objects con treesitter               │
      -- └──────────────────────────────────────────────────────────────────┘
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

      -- ┌──────────────────────────────────────────────────────────────────┐
      -- │  REPEATABLE MOVES - Repetir movimientos con ; y ,               │
      -- └──────────────────────────────────────────────────────────────────┘
      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      -- ; repite hacia adelante, , repite hacia atrás (consistente)
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
      vim.keymap.set(
        { "n", "x", "o" },
        ",",
        ts_repeat_move.repeat_last_move_previous,
        { desc = "Repeat last move prev" }
      )

      -- Hacer f, F, t, T también repetibles con ; y ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         TREESITTER CONTEXT                               │
  -- │            Muestra el contexto de la función/clase actual                │
  -- └──────────────────────────────────────────────────────────────────────────┘
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

  -- Mini.ai - Extended text objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().googletag.teleport" },
          d = { "%f[%d]%d+" }, -- Digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*googletag.teleport",
          },
          u = ai.gen_spec.function_call(), -- u for "usage" (function call)
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- sin dot
        },
      }
    end,
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

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         TS CONTEXT COMMENTSTRING                         │
  -- │              Comentarios correctos según contexto (JSX, etc)             │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              TODO COMMENTS                               │
  -- │                    Highlight TODO, FIXME, etc                            │
  -- └──────────────────────────────────────────────────────────────────────────┘
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
}
