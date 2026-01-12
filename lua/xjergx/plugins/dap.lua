-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              DAP (Debug)                                 ║
-- ║                    Debug Adapter Protocol plugins                        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              NVIM-DAP                                    │
  -- │                         Debug Adapter Protocol                           │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- Virtual text
      "theHamsta/nvim-dap-virtual-text",
      -- Mason integration
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      -- Language specific
      "mfussenegger/nvim-dap-python", -- Python (opcional)
    },
    keys = {
      -- Breakpoints
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Log Point",
      },
      -- Execution
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>ds",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dn",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      -- Session
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
        desc = "Restart",
      },
      {
        "<leader>dq",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dR",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      -- UI
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "DAP UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "Eval",
      },
      -- Launch
      {
        "<leader>da",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
    },
    config = function()
      local dap = require("dap")

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                           SIGNS                                    ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰁕 ", texthl = "DiagnosticOk", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })

      -- Highlight para línea parada
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                    C# / .NET CONFIGURATION                         ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch - netcoredbg",
          request = "launch",
          program = function()
            -- Buscar el DLL del proyecto
            local cwd = vim.fn.getcwd()
            local dll = vim.fn.glob(cwd .. "/bin/Debug/**/**.dll", false, true)
            if #dll > 0 then
              return dll[1]
            end
            return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "coreclr",
          name = "Attach - netcoredbg",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                 JAVASCRIPT/TYPESCRIPT CONFIGURATION                ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      -- js-debug-adapter (vscode-js-debug)
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      -- Configs para JS/TS
      for _, lang in ipairs({ "javascript", "typescript" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Vue hereda de typescript
      dap.configurations.vue = dap.configurations.typescript

      -- ╔════════════════════════════════════════════════════════════════════╗
      -- ║                      LUA CONFIGURATION                             ║
      -- ╚════════════════════════════════════════════════════════════════════╝
      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              DAP-UI                                      │
  -- │                         Debug UI bonita                                  │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      element_mappings = {},
      expand_lines = true,
      force_buffers = true,
      floating = {
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
        },
      },
      render = {
        max_type_length = nil,
        max_value_lines = 100,
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      -- Auto-open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         DAP VIRTUAL TEXT                                 │
  -- │                 Muestra valores inline mientras debugeas                 │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      virt_text_pos = "eol",
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                         MASON-NVIM-DAP                                   │
  -- │                   Auto-install debug adapters                            │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "netcoredbg", -- C#
        "js-debug-adapter", -- JavaScript/TypeScript
      },
      handlers = {},
    },
  },
}
