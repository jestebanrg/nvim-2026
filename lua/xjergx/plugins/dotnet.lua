return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "csproj", "sln", "fs", "fsproj", "razor" },
    cmd = { "Dotnet" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>nb",
        function()
          require("easy-dotnet").build()
        end,
        desc = ".NET Build",
      },
      {
        "<leader>nr",
        function()
          require("easy-dotnet").run()
        end,
        desc = ".NET Run",
      },
      {
        "<leader>nw",
        function()
          require("easy-dotnet").watch()
        end,
        desc = ".NET Watch",
      },
      {
        "<leader>nS",
        function()
          require("easy-dotnet").secrets()
        end,
        desc = ".NET Secrets",
      },
    },
    opts = {
      picker = "snacks",
      lsp = {
        enabled = false,
      },
      debugger = {
        auto_register_dap = false,
      },
      csproj_mappings = true,
      fsproj_mappings = true,
    },
  },
}
