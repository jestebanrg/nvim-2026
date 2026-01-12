-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              NAVIGATION                                  ║
-- ║              Oil, Harpoon, Marker Groups, Flash, and tmux nav            ║
-- ║          (Telescope replaced by snacks.picker in snacks.lua)             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              OIL.NVIM                                    │
  -- │                  File explorer as a buffer (like dirvish)                │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<Cmd>Oil<CR>", desc = "Open Oil" },
      { "<leader>e", "<Cmd>Oil<CR>", desc = "Explorer (Oil)" },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name)
          return vim.startswith(name, ".")
        end,
        is_always_hidden = function(name)
          return name == ".." or name == ".git"
        end,
      },
      float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              HARPOON                                     │
  -- │                  Quick file navigation (bookmarks)                       │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<leader>ha",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon Add File",
        },
        {
          "<leader>hh",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Menu",
        },
        {
          "<leader>hp",
          function()
            require("harpoon"):list():prev()
          end,
          desc = "Harpoon Prev",
        },
        {
          "<leader>hn",
          function()
            require("harpoon"):list():next()
          end,
          desc = "Harpoon Next",
        },
      }

      -- Quick access 1-5
      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end

      return keys
    end,
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              MARKER GROUPS                               │
  -- │                  Persistent code notes without modifying code            │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "jameswolensky/marker-groups.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      drawer_config = {
        width = 60,
        side = "right",
        border = "rounded",
      },
      context_lines = 3,
      picker = "snacks",
      keymaps = {
        enabled = true,
        prefix = "<leader>m",
      },
    },
    keys = {
      { "<leader>ma", "<cmd>MarkerAdd<cr>", mode = { "n", "v" }, desc = "Add marker" },
      { "<leader>mv", "<cmd>MarkerGroupsView<cr>", desc = "View markers (drawer)" },
      { "<leader>mgc", "<cmd>MarkerGroupsCreate<cr>", desc = "Create group" },
      { "<leader>mgl", "<cmd>MarkerGroupsList<cr>", desc = "List groups" },
      { "<leader>mgs", "<cmd>MarkerGroupsSelect<cr>", desc = "Select group" },
      { "<leader>mgr", "<cmd>MarkerGroupsRename<cr>", desc = "Rename group" },
      { "<leader>mgd", "<cmd>MarkerGroupsDelete<cr>", desc = "Delete group" },
      { "<leader>md", "<cmd>MarkerRemove<cr>", desc = "Delete marker at cursor" },
      { "<leader>ml", "<cmd>MarkerList<cr>", desc = "List markers in buffer" },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              FLASH.NVIM                                  │
  -- │                  Navigate code like a ninja (hop/leap)                   │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        mode = "exact",
        incremental = true,
      },
      label = {
        uppercase = false,
        rainbow = {
          enabled = true,
          shade = 5,
        },
      },
      modes = {
        char = {
          jump_labels = true,
        },
        search = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              TMUX NAVIGATOR                              │
  -- │                  Seamless navigation between vim and tmux                │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
  },
}
