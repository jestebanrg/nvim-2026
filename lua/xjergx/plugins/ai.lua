return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    build = ":Codeium Auth",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        manual = false,
        idle_delay = 75,
        virtual_text_priority = 65535,
        key_bindings = {
          accept = "<Tab>",
          accept_word = "<C-;>",
          accept_line = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
          clear = "<C-]>",
        },
      },
    },
    keys = {
      { "<leader>ci", "<cmd>Codeium Auth<cr>", desc = "Codeium Auth" },
      { "<leader>ce", "<cmd>Codeium Enable<cr>", desc = "Codeium Enable" },
      { "<leader>cD", "<cmd>Codeium Disable<cr>", desc = "Codeium Disable" },
      { "<leader>ct", "<cmd>Codeium Toggle<cr>", desc = "Codeium Toggle" },
      { "<leader>cH", "<cmd>Codeium Chat<cr>", desc = "Codeium Chat" },
    },
  },
  -- {
  --   "coder/claudecode.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   cmd = {
  --     "ClaudeCode",
  --     "ClaudeCodeFocus",
  --     "ClaudeCodeSend",
  --     "ClaudeCodeAdd",
  --     "ClaudeCodeTreeAdd",
  --     "ClaudeCodeDiffAccept",
  --     "ClaudeCodeDiffDeny",
  --     "ClaudeCodeSelectModel",
  --   },
  --   opts = {
  --     auto_start = true,
  --     log_level = "info",
  --
  --     terminal = {
  --       split_side = "right",
  --       split_width_percentage = 0.40,
  --       provider = "snacks",
  --     },
  --
  --     diff_opts = {
  --       auto_close_on_accept = true,
  --       vertical_split = true,
  --       open_in_current_tab = true,
  --     },
  --   },
  --   keys = {
  --     { "<leader>a", nil, desc = "AI/Claude Code" },
  --     { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
  --     { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
  --     { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
  --     { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
  --     { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
  --     { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
  --     { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  --     {
  --       "<leader>as",
  --       "<cmd>ClaudeCodeTreeAdd<cr>",
  --       desc = "Add file",
  --       ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  --     },
  --     -- Diff management
  --     { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
  --     { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  --   },
  -- },
}
