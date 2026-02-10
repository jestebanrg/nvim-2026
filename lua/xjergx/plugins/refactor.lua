return {
  {
    "smjonas/inc-rename.nvim",
    event = "LspAttach",
    opts = {
      input_buffer_type = "snacks",
      preview_empty_name = false,
      show_message = true,
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      show_success_message = true,
    },
    keys = {
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor({ prefer_ex_cmd = true })
        end,
        mode = { "n", "x" },
        desc = "Refactor Menu",
      },
      { "<leader>re", ":Refactor extract ", mode = "x", desc = "Extract Function" },
      { "<leader>rE", ":Refactor extract_to_file ", mode = "x", desc = "Extract Function To File" },
      { "<leader>rv", ":Refactor extract_var ", mode = "x", desc = "Extract Variable" },
      { "<leader>ri", ":Refactor inline_var<CR>", mode = { "n", "x" }, desc = "Inline Variable" },
      { "<leader>rI", ":Refactor inline_func<CR>", mode = "n", desc = "Inline Function" },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.printf({ below = false })
        end,
        mode = "n",
        desc = "Debug Printf",
      },
      {
        "<leader>rP",
        function()
          require("refactoring").debug.print_var()
        end,
        mode = { "n", "x" },
        desc = "Debug Print Variable",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup({})
        end,
        mode = "n",
        desc = "Debug Cleanup Prints",
      },
    },
  },
}
