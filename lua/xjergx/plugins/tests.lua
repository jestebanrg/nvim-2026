return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "marilari88/neotest-vitest",
    "Issafalcon/neotest-dotnet",
  },
  keys = {
    {
      "<leader>Tn",
      function()
        require("neotest").run.run()
      end,
      desc = "Run nearest test",
    },
    {
      "<leader>Tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run file tests",
    },
    {
      "<leader>Td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug nearest test",
    },
    {
      "<leader>Ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle test summary",
    },
    {
      "<leader>To",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Open test output",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest")({
          filter_dir = function(name, rel_path, root)
            return name ~= "node_modules"
          end,
        }),
        require("neotest-dotnet")({
          discovery_root = "solution",
          dap = {
            adapter_name = "coreclr",
          },
          dotnet_additional_args = {
            "--verbosity",
            "minimal",
          },
        }),
      },
    })
  end,
}
