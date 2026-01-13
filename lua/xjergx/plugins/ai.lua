-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              AI ASSISTANTS                               ║
-- ║               Claude Code, OpenCode, and AI integrations                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              CODEIUM                                     │
  -- │            AI-powered code completion (Windsurf engine)                  │
  -- │                 https://github.com/Exafunction/codeium.nvim             │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    build = ":Codeium Auth",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      enable_cmp_source = false, -- Usamos blink, no nvim-cmp
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
      { "<leader>cd", "<cmd>Codeium Disable<cr>", desc = "Codeium Disable" },
      { "<leader>ct", "<cmd>Codeium Toggle<cr>", desc = "Codeium Toggle" },
      { "<leader>cs", "<cmd>Codeium Chat<cr>", desc = "Codeium Chat" },
    },
  },
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                            CLAUDE CODE                                   │
  -- │           Anthropic's Claude Code IDE integration for Neovim            │
  -- │               https://github.com/coder/claudecode.nvim                  │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeSelectModel",
    },
    opts = {
      -- Server Configuration
      auto_start = true,
      log_level = "info",

      -- Terminal Configuration
      terminal = {
        split_side = "right",
        split_width_percentage = 0.40,
        provider = "snacks",
      },

      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                             OPENCODE                                     │
  -- │          OpenCode AI assistant integration for Neovim                    │
  -- │             https://github.com/NickvanDyke/opencode.nvim                │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    keys = {
      {
        "<leader>oc",
        function()
          require("opencode").toggle()
        end,
        mode = { "n" },
        desc = "Toggle OpenCode",
      },
      {
        "<leader>os",
        function()
          require("opencode").select({ submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode select",
      },
      {
        "<leader>oi",
        function()
          require("opencode").ask("", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode ask",
      },
      {
        "<leader>oI",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode ask with context",
      },
      {
        "<leader>ob",
        function()
          require("opencode").ask("@file ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode ask about buffer",
      },
      {
        "<leader>op",
        function()
          require("opencode").prompt("@this", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode prompt",
      },
      -- Built-in prompts
      {
        "<leader>ope",
        function()
          require("opencode").prompt("explain", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode explain",
      },
      {
        "<leader>opf",
        function()
          require("opencode").prompt("fix", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode fix",
      },
      {
        "<leader>opd",
        function()
          require("opencode").prompt("diagnose", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode diagnose",
      },
      {
        "<leader>opr",
        function()
          require("opencode").prompt("review", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode review",
      },
      {
        "<leader>opt",
        function()
          require("opencode").prompt("test", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode test",
      },
      {
        "<leader>opo",
        function()
          require("opencode").prompt("optimize", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "OpenCode optimize",
      },
    },
    config = function()
      vim.g.opencode_opts = {
        provider = {
          snacks = {
            win = {
              position = "right",
              width = 0.40,
            },
          },
        },
      }
      vim.o.autoread = true
    end,
  },
}
