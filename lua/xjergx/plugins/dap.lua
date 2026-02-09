return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
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
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: "))
        end,
        desc = "Log Point",
      },
      {
        "<leader>dx",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Clear All Breakpoints",
      },

      -- Execution
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue / Start",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
        desc = "Restart",
      },

      -- Stepping
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dn",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },

      -- UI
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval(nil, { enter = true })
        end,
        mode = { "n", "v" },
        desc = "Evaluate (enter float)",
      },
      {
        "<leader>dE",
        function()
          vim.ui.input({ prompt = "  Expression: " }, function(expr)
            if expr and expr ~= "" then
              require("dapui").eval(expr, { enter = true })
            end
          end)
        end,
        desc = "Evaluate Input",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        mode = { "n", "v" },
        desc = "Hover (quick peek)",
      },
      {
        "<leader>dp",
        function()
          require("dap.ui.widgets").preview()
        end,
        mode = { "n", "v" },
        desc = "Preview",
      },
      {
        "<leader>dw",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Scopes (float)",
      },
      {
        "<leader>df",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "Frames (float)",
      },
      {
        "<leader>dR",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },

      -- Function keys
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<S-F11>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<F12>",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_path = vim.fn.stdpath("data") .. "/mason"

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                           MASON-DAP SETUP                              ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      require("mason-nvim-dap").setup({
        ensure_installed = { "netcoredbg", "js-debug-adapter" },
        automatic_installation = true,
        handlers = {},
      })

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                              DAP-UI SETUP                              ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "→",
        },
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
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 50,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 0.25,
            position = "bottom",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "↓",
            step_over = "→",
            step_out = "↑",
            step_back = "←",
            run_last = "↻",
            terminate = "■",
            disconnect = "⏏",
          },
        },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
          indent = 1,
        },
      })

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                           VIRTUAL TEXT                                 ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        highlight_changed_variables = true,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol",
      })

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                           SIGNS & HIGHLIGHTS                           ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected" })

      -- Breakpoint icons
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#f38ba8" }) -- Rosa suave
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#fab387" }) -- Peach
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#89dceb" }) -- Sky blue
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#585b70" }) -- Gris

      -- Línea actual de debugging - el más lindo 😎
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#a6e3a1" }) -- Verde brillante para el icono
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2d4f2d", bold = true }) -- Fondo verde oscuro elegante

      -- Número de línea cuando está parado ahí
      vim.api.nvim_set_hl(0, "DapStoppedLineNr", { fg = "#a6e3a1", bold = true })

      -- Actualizar el sign para incluir numhl
      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStoppedLineNr",
      })

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                        AUTO OPEN/CLOSE UI                              ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()

        -- K para hover durante debugging (guarda el original para restaurar después)
        vim.keymap.set({ "n", "v" }, "K", function()
          require("dap.ui.widgets").hover()
        end, { desc = "DAP Hover", buffer = false })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                         ADAPTER: .NET (netcoredbg)                     ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      local netcoredbg_path = mason_path .. "/bin/netcoredbg"

      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_path,
        args = { "--interpreter=vscode" },
      }

      -- Helper: Find .NET DLL
      local function find_dotnet_dll(project_name)
        local cwd = vim.fn.getcwd()
        local paths = {
          cwd .. "/src/" .. project_name .. "/bin/Debug/net10.0/" .. project_name .. ".dll",
          cwd .. "/src/" .. project_name .. "/bin/Debug/net9.0/" .. project_name .. ".dll",
          cwd .. "/src/" .. project_name .. "/bin/Debug/net8.0/" .. project_name .. ".dll",
          cwd .. "/" .. project_name .. "/bin/Debug/net10.0/" .. project_name .. ".dll",
        }
        for _, path in ipairs(paths) do
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end
        return nil
      end

      -- Helper: Get running dotnet processes
      local function get_dotnet_processes()
        local handle = io.popen("pgrep -la dotnet 2>/dev/null")
        if not handle then
          return {}
        end
        local result = handle:read("*a")
        handle:close()
        local processes = {}
        for line in result:gmatch("[^\r\n]+") do
          local pid, cmd = line:match("(%d+)%s+(.+)")
          if pid then
            table.insert(processes, { pid = tonumber(pid), name = cmd })
          end
        end
        return processes
      end

      -- ┌────────────────────────────────────────────────────────────────────────┐
      -- │                      .NET CONFIGURATIONS                               │
      -- └────────────────────────────────────────────────────────────────────────┘
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "🚀 Launch Structo.WebApi (HTTPS)",
          request = "launch",
          program = function()
            local dll = find_dotnet_dll("Structo.WebApi")
            if dll then
              return dll
            end
            return vim.fn.input(
              "Path to DLL: ",
              vim.fn.getcwd() .. "/src/Structo.WebApi/bin/Debug/net10.0/Structo.WebApi.dll",
              "file"
            )
          end,
          cwd = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.isdirectory(cwd .. "/src/Structo.WebApi") == 1 then
              return cwd .. "/src/Structo.WebApi"
            end
            return cwd
          end,
          stopOnEntry = false,
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
            ASPNETCORE_URLS = "https://localhost:5001;http://localhost:5000",
            -- Opcional: si necesitás dev certs sin validación
            DOTNET_SYSTEM_NET_HTTP_SOCKETSHTTPHANDLER_HTTP3SUPPORT = "false",
          },
          console = "integratedTerminal",
        },
        {
          type = "coreclr",
          name = "🔓 Launch Structo.WebApi (HTTP only)",
          request = "launch",
          program = function()
            local dll = find_dotnet_dll("Structo.WebApi")
            if dll then
              return dll
            end
            return vim.fn.input(
              "Path to DLL: ",
              vim.fn.getcwd() .. "/src/Structo.WebApi/bin/Debug/net10.0/Structo.WebApi.dll",
              "file"
            )
          end,
          cwd = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.isdirectory(cwd .. "/src/Structo.WebApi") == 1 then
              return cwd .. "/src/Structo.WebApi"
            end
            return cwd
          end,
          stopOnEntry = false,
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
            ASPNETCORE_URLS = "http://localhost:5000",
          },
          console = "integratedTerminal",
        },
        {
          type = "coreclr",
          name = "🔧 Launch .NET Project (select DLL)",
          request = "launch",
          program = function()
            return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          console = "integratedTerminal",
        },
        {
          type = "coreclr",
          name = "🔗 Attach to .NET Process",
          request = "attach",
          processId = function()
            local processes = get_dotnet_processes()
            if #processes == 0 then
              print("No .NET processes found")
              return nil
            end
            local items = { "Select process:" }
            for _, p in ipairs(processes) do
              table.insert(items, string.format("%d: %s", p.pid, p.name))
            end
            local choice = vim.fn.inputlist(items)
            if choice > 0 and choice <= #processes then
              return processes[choice].pid
            end
            return nil
          end,
        },
        {
          type = "coreclr",
          name = "🧪 Debug Unit Tests",
          request = "launch",
          program = function()
            local dll = find_dotnet_dll("Structo.Tests.Unit")
            if dll then
              return dll
            end
            return vim.fn.input(
              "Path to test DLL: ",
              vim.fn.getcwd() .. "/test/Structo.Tests.Unit/bin/Debug/net10.0/Structo.Tests.Unit.dll",
              "file"
            )
          end,
          cwd = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.isdirectory(cwd .. "/test/Structo.Tests.Unit") == 1 then
              return cwd .. "/test/Structo.Tests.Unit"
            end
            return cwd
          end,
          stopOnEntry = false,
          console = "integratedTerminal",
        },
        {
          type = "coreclr",
          name = "🧪 Debug Integration Tests",
          request = "launch",
          program = function()
            local dll = find_dotnet_dll("Structo.Tests.Integration")
            if dll then
              return dll
            end
            return vim.fn.input(
              "Path to test DLL: ",
              vim.fn.getcwd() .. "/test/Structo.Tests.Integration/bin/Debug/net10.0/Structo.Tests.Integration.dll",
              "file"
            )
          end,
          cwd = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.isdirectory(cwd .. "/test/Structo.Tests.Integration") == 1 then
              return cwd .. "/test/Structo.Tests.Integration"
            end
            return cwd
          end,
          stopOnEntry = false,
          console = "integratedTerminal",
        },
      }

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                    ADAPTER: JavaScript/TypeScript                      ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      local js_debug_path = mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      dap.adapters["node"] = dap.adapters["pwa-node"]
      dap.adapters["chrome"] = dap.adapters["pwa-chrome"]

      -- ┌────────────────────────────────────────────────────────────────────────┐
      -- │              JAVASCRIPT/TYPESCRIPT CONFIGURATIONS                      │
      -- └────────────────────────────────────────────────────────────────────────┘
      local js_configs = {
        {
          type = "pwa-node",
          name = "🚀 Launch Current File (Node)",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
          type = "pwa-node",
          name = "🟢 Nuxt Dev Server",
          request = "launch",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          cwd = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.filereadable(cwd .. "/nuxt.config.ts") == 1 then
              return cwd
            end
            return vim.fn.input("Nuxt project path: ", cwd, "dir")
          end,
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          name = "🔗 Attach to Node Process",
          request = "attach",
          processId = function()
            return require("dap.utils").pick_process({
              filter = function(proc)
                return proc.name:match("node") or proc.name:match("nuxt")
              end,
            })
          end,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        },
        {
          type = "pwa-node",
          name = "🔗 Attach to Port 9229",
          request = "attach",
          port = 9229,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        },
        {
          type = "pwa-chrome",
          name = "🌐 Launch Chrome (localhost:3000)",
          request = "launch",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          userDataDir = false,
        },
        {
          type = "pwa-chrome",
          name = "🌐 Attach to Chrome (port 9222)",
          request = "attach",
          port = 9222,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          name = "🧪 Debug Vitest Tests",
          request = "launch",
          runtimeExecutable = "npx",
          runtimeArgs = { "vitest", "run", "--reporter=verbose", "--no-coverage" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          name = "🧪 Debug Current Test File",
          request = "launch",
          runtimeExecutable = "npx",
          runtimeArgs = function()
            return { "vitest", "run", vim.fn.expand("%:p"), "--reporter=verbose" }
          end,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "**/node_modules/**" },
          console = "integratedTerminal",
        },
      }

      dap.configurations.javascript = js_configs
      dap.configurations.typescript = js_configs
      dap.configurations.javascriptreact = js_configs
      dap.configurations.typescriptreact = js_configs
      dap.configurations.vue = js_configs

      -- ╔════════════════════════════════════════════════════════════════════════╗
      -- ║                           COMMANDS                                     ║
      -- ╚════════════════════════════════════════════════════════════════════════╝
      vim.api.nvim_create_user_command("DapRunLast", function()
        dap.run_last()
      end, { desc = "Re-run last debug configuration" })

      vim.api.nvim_create_user_command("DapConfigs", function()
        local ft = vim.bo.filetype
        local configs = dap.configurations[ft]
        if not configs then
          print("No DAP configurations for filetype: " .. ft)
          return
        end
        print("Available configurations for " .. ft .. ":")
        for i, c in ipairs(configs) do
          print(string.format("  %d. %s", i, c.name))
        end
      end, { desc = "Show DAP configurations" })

      vim.api.nvim_create_user_command("DapBuildAndDebug", function()
        if vim.bo.filetype == "cs" then
          print("Building .NET project...")
          vim.fn.system("dotnet build")
          print("Build complete. Starting debugger...")
        end
        dap.continue()
      end, { desc = "Build and start debugging" })
    end,
  },

  { "rcarriga/nvim-dap-ui", lazy = true },
  { "theHamsta/nvim-dap-virtual-text", lazy = true },
  { "nvim-neotest/nvim-nio", lazy = true },
}
