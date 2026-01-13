-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              LSP PLUGINS                                 ║
-- ║                  Language Server Protocol Configuration                  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              MASON                                       │
  -- │                     Package manager para LSP, etc                        │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         MASON-LSPCONFIG                                  │
  -- │                  Bridge entre Mason y lspconfig                          │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Tu stack
        "vtsls", -- TypeScript/JavaScript (reemplaza ts_ls)
        "vue_ls", -- Vue 3 (formerly volar)
        "omnisharp", -- C#
        "lua_ls", -- Lua
        -- Web extras
        "html",
        "cssls",
        "tailwindcss",
        "emmet_ls",
        "jsonls",
        -- Config
        "yamlls",
        -- Docker
        "dockerls",
        "docker_compose_language_service",
      },
      automatic_installation = true,
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              NVIM-LSPCONFIG                              │
  -- │                         LSP Client Configuration                         │
  -- │          Using vim.lsp.config (Neovim 0.11+ native approach)             │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Autocompletion capabilities
      "saghen/blink.cmp",
      -- Schema store para JSON/YAML
      "b0o/schemastore.nvim",
    },
    config = function()
      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                         DIAGNOSTICS CONFIG                         ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                         CAPABILITIES                               ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )

      -- Habilitar file watching
      capabilities.workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      }

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                    LSP ATTACH AUTOCMD (Neovim 0.11+)               ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_config", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          -- Navigation (using snacks.picker - defined in snacks.lua)
          -- NOTE: gd, gr, gI, gy are mapped in snacks.lua to snacks.picker
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")

          -- Hover & Signature
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

          -- Actions
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>cR", function()
            require("snacks").rename.rename_file()
          end, "Rename File")

          -- Workspace
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List Workspace Folders")

          -- Inlay Hints (Neovim 0.10+)
          if client and client.supports_method("textDocument/inlayHint") then
            map("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, "Toggle Inlay Hints")
          end

          -- Code Lens
          if client and client.supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = bufnr,
              callback = vim.lsp.codelens.refresh,
            })
            map("n", "<leader>cl", vim.lsp.codelens.run, "Run Code Lens")
          end

          -- Document Highlight
          if client and client.supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp_highlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = highlight_augroup,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = highlight_augroup,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- OmniSharp specific keymaps
          if client and client.name == "omnisharp" then
            vim.keymap.set("n", "gd", function()
              require("omnisharp_extended").lsp_definition()
            end, { buffer = bufnr, desc = "Goto Definition (OmniSharp)" })
          end
        end,
      })

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║              SERVER CONFIGS (vim.lsp.config - Neovim 0.11+)        ║
      -- ╚════════════════════════════════════════════════════════════════════╝

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │                     TYPESCRIPT (vtsls + Vue plugin)                │
      -- │          vtsls maneja TS/JS y el plugin de Vue para .vue           │
      -- └────────────────────────────────────────────────────────────────────┘
      -- Path al language server de Vue (necesario para el plugin)
      local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
      local vue_language_server_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │                         VUE 3 (Hybrid Mode)                        │
      -- │       vue_ls maneja HTML/CSS, vtsls maneja TS via plugin           │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.lsp.config("vue_ls", {
        capabilities = capabilities,
        filetypes = { "vue" },
        init_options = {
          vue = {
            hybridMode = true,
          },
        },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │                              C#                                    │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.lsp.config("omnisharp", {
        capabilities = capabilities,
        cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = true,
          },
        },
        handlers = {
          ["textDocument/definition"] = function(...)
            return require("omnisharp_extended").handler(...)
          end,
        },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │                              LUA                                   │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                "${3rd}/luv/library",
                unpack(vim.api.nvim_get_runtime_file("", true)),
              },
            },
            completion = {
              callSnippet = "Replace",
            },
            telemetry = { enable = false },
            hint = {
              enable = true,
              setType = true,
              paramType = true,
              paramName = "All",
              semicolon = "SameLine",
              arrayIndex = "Enable",
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │                              JSON                                  │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │                              YAML                                  │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │                        SIMPLE SERVERS                              │
      -- │         (html, cssls, tailwindcss, emmet_ls, docker)               │
      -- └────────────────────────────────────────────────────────────────────┘
      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.config("cssls", { capabilities = capabilities })
      vim.lsp.config("tailwindcss", {
        capabilities = capabilities,
        filetypes = { "html", "css", "scss", "javascript", "typescript", "vue", "svelte" },
      })
      vim.lsp.config("emmet_ls", {
        capabilities = capabilities,
        filetypes = { "html", "css", "scss", "vue", "typescriptreact", "javascriptreact" },
      })
      vim.lsp.config("dockerls", { capabilities = capabilities })
      vim.lsp.config("docker_compose_language_service", { capabilities = capabilities })

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                     ENABLE ALL SERVERS                             ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      vim.lsp.enable({
        "vtsls",
        "vue_ls",
        "omnisharp",
        "lua_ls",
        "jsonls",
        "yamlls",
        "html",
        "cssls",
        "tailwindcss",
        "emmet_ls",
        "dockerls",
        "docker_compose_language_service",
      })
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         OMNISHARP EXTENDED                               │
  -- │                   Better go-to-definition para C#                        │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    lazy = true,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         SCHEMA STORE                                     │
  -- │                   JSON/YAML schemas collection                           │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         FIDGET                                           │
  -- │                   LSP progress indicator                                 │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      progress = {
        display = {
          done_icon = "✓",
        },
      },
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         GOTO PREVIEW                                     │
  -- │              Preview definitions/implementations en floating window      │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    opts = {
      width = 120,
      height = 25,
      border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
      default_mappings = false,
      resizing_mappings = false,
      post_open_hook = function(buf, win)
        -- Cerrar con q o <Esc>
        vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = buf, nowait = true })
        vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = buf, nowait = true })
      end,
    },
    keys = {
      { "gpd", function() require("goto-preview").goto_preview_definition() end, desc = "Preview Definition" },
      { "gpD", function() require("goto-preview").goto_preview_declaration() end, desc = "Preview Declaration" },
      { "gpi", function() require("goto-preview").goto_preview_implementation() end, desc = "Preview Implementation" },
      { "gpy", function() require("goto-preview").goto_preview_type_definition() end, desc = "Preview Type Definition" },
      { "gpr", function() require("goto-preview").goto_preview_references() end, desc = "Preview References" },
      { "gP", function() require("goto-preview").close_all_win() end, desc = "Close all preview windows" },
    },
  },
}
