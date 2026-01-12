-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              FORMATTING                                  ║
-- ║                   Code formatting with conform.nvim                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              CONFORM                                     │
  -- │                     Formatter plugin moderno                             │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ async = true, lsp_fallback = true, formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      formatters_by_ft = {
        -- JavaScript/TypeScript
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },

        -- Vue
        vue = { "prettier" },

        -- Web
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },

        -- Data
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },

        -- Markdown
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },

        -- Lua
        lua = { "stylua" },

        -- C#
        cs = { "csharpier" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        -- GraphQL
        graphql = { "prettier" },

        -- Docker
        dockerfile = { "hadolint" },

        -- Misc
        ["_"] = { "trim_whitespace" },
      },

      -- Format on save
      format_on_save = function(bufnr)
        -- Disable con variable global
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable para ciertos filetypes
        local ignore_filetypes = { "sql", "java" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- Disable para archivos grandes
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if vim.fn.getfsize(bufname) > 1024 * 1024 then
          return
        end
        return {
          timeout_ms = 3000,
          lsp_fallback = true,
        }
      end,

      -- Formatters custom config
      formatters = {
        prettier = {
          prepend_args = { "--single-quote", "--trailing-comma", "es5" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-bn" },
        },
      },
    },
    init = function()
      -- Comandos para toggle format on save
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
        vim.notify("Autoformat disabled", vim.log.levels.INFO)
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
        vim.notify("Autoformat enabled", vim.log.levels.INFO)
      end, {
        desc = "Enable autoformat-on-save",
      })

      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          vim.notify("Autoformat disabled", vim.log.levels.INFO)
        else
          vim.notify("Autoformat enabled", vim.log.levels.INFO)
        end
      end, {
        desc = "Toggle autoformat-on-save",
      })

      -- Keymap para toggle
      vim.keymap.set("n", "<leader>uf", "<Cmd>FormatToggle<CR>", { desc = "Toggle autoformat" })
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              MASON-CONFORM                               │
  -- │                   Auto-install formatters                                │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
    opts = {},
  },
}
