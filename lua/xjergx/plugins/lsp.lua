return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
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
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "vtsls", -- TypeScript/JavaScript (reemplaza ts_ls)
        "vue_ls", -- Vue 3 (formerly volar)
        "html",
        "cssls",
        "emmet_ls",
        "jsonls",
        "yamlls",
        "dockerls",
      },
      automatic_installation = true,
    },
  },
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

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )

      capabilities.workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      }

      if vim.g.lsp_auto_organize_imports == nil then
        if vim.g.vtsls_auto_organize_imports ~= nil then
          vim.g.lsp_auto_organize_imports = vim.g.vtsls_auto_organize_imports
        else
          vim.g.lsp_auto_organize_imports = true
        end
      end

      if vim.g.vtsls_auto_add_missing_imports == nil then
        vim.g.vtsls_auto_add_missing_imports = true
      end

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

          -- NOTE: gd, gr, gI, gy are mapped in snacks.lua to snacks.picker
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")

          -- Hover & Signature
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

          -- Actions
          map({ "n", "v" }, "<leader>ca", function()
            require("tiny-code-action").code_action()
          end, "Code Action")
          -- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", function()
            local ok = pcall(require, "inc_rename")
            if ok then
              vim.api.nvim_feedkeys(":IncRename " .. vim.fn.expand("<cword>"), "n", false)
              return
            end
            vim.lsp.buf.rename()
          end, "Rename")
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

          -- Auto organize imports on save for vtsls and roslyn
          if client
            and vim.tbl_contains({ "vtsls", "roslyn" }, client.name)
            and client.supports_method("textDocument/codeAction")
          then
            local organize_imports_group =
              vim.api.nvim_create_augroup("lsp_" .. client.name .. "_organize_imports_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = organize_imports_group,
              buffer = bufnr,
              callback = function()
                if vim.g.lsp_auto_organize_imports == false and vim.g.vtsls_auto_add_missing_imports == false then
                  return
                end

                local apply_code_actions = function(action_kinds)
                  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
                  params.context = { only = action_kinds, diagnostics = {} }

                  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
                  if not result then
                    return
                  end

                  for _, res in pairs(result) do
                    for _, action in pairs(res.result or {}) do
                      if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                      end
                      if action.command then
                        client:exec_cmd(action.command, { bufnr = bufnr })
                      end
                    end
                  end
                end

                if client.name == "vtsls" and vim.g.vtsls_auto_add_missing_imports ~= false then
                  apply_code_actions({ "source.addMissingImports.ts", "source.addMissingImports" })
                end

                if vim.g.lsp_auto_organize_imports ~= false then
                  apply_code_actions({ "source.organizeImports" })
                end
              end,
              desc = "Auto import/organize imports (vtsls/roslyn)",
            })
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
      vim.lsp.config("roslyn", {
        capabilities = capabilities,
        settings = {
          navigation = {
            dotnet_navigate_to_decompiled_sources = true,
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
          ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
          },
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
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
        "roslyn",
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

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║              FIX: Attach LSP to already opened buffers             ║
      -- ║       (el primer buffer se abre antes de que el LSP esté listo)    ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      vim.schedule(function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            if #clients == 0 then
              -- Re-trigger FileType para que el LSP se attachee
              local ft = vim.bo[bufnr].filetype
              if ft and ft ~= "" then
                vim.api.nvim_buf_call(bufnr, function()
                  vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr })
                end)
              end
            end
          end
        end
      end)
    end,
  },

  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    opts = {
      broad_search = true,
      lock_target = true,
    },
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
      {
        "gpd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Preview Definition",
      },
      {
        "gpD",
        function()
          require("goto-preview").goto_preview_declaration()
        end,
        desc = "Preview Declaration",
      },
      {
        "gpi",
        function()
          require("goto-preview").goto_preview_implementation()
        end,
        desc = "Preview Implementation",
      },
      {
        "gpy",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
        desc = "Preview Type Definition",
      },
      {
        "gpr",
        function()
          require("goto-preview").goto_preview_references()
        end,
        desc = "Preview References",
      },
      {
        "gP",
        function()
          require("goto-preview").close_all_win()
        end,
        desc = "Close all preview windows",
      },
    },
  },
}
