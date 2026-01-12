-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              GIT PLUGINS                                 ║
-- ║                Git integration, signs, diffview, neogit                  ║
-- ║           (lazygit.nvim replaced by snacks.lazygit in snacks.lua)        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              GITSIGNS                                    │
  -- │                     Git signs in the gutter                              │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      preview_config = {
        border = "rounded",
        style = "minimal",
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function()
          gs.nav_hunk("last")
        end, "Last Hunk")
        map("n", "[H", function()
          gs.nav_hunk("first")
        end, "First Hunk")

        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghP", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>ghB", function()
          gs.blame()
        end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")

        -- Toggle
        map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>gtd", gs.toggle_deleted, "Toggle Deleted")
        map("n", "<leader>gtw", gs.toggle_word_diff, "Toggle Word Diff")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              DIFFVIEW                                    │
  -- │                  Git diff in a fancy tabpage view                        │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>gq", "<Cmd>DiffviewClose<CR>", desc = "Diffview Close" },
      { "<leader>gF", "<Cmd>DiffviewFileHistory %<CR>", desc = "File History" },
      { "<leader>gH", "<Cmd>DiffviewFileHistory<CR>", desc = "Branch History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },

  -- ┌──────────────────────────────────────────────────────────────────────────┐
  -- │                              NEOGIT                                      │
  -- │                      Magit clone for Neovim                              │
  -- └──────────────────────────────────────────────────────────────────────────┘
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gn", "<Cmd>Neogit<CR>", desc = "Neogit" },
      { "<leader>gc", "<Cmd>Neogit commit<CR>", desc = "Neogit Commit" },
      { "<leader>gp", "<Cmd>Neogit push<CR>", desc = "Neogit Push" },
      { "<leader>gP", "<Cmd>Neogit pull<CR>", desc = "Neogit Pull" },
    },
    opts = {
      graph_style = "unicode",
      integrations = {
        diffview = true,
      },
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
    },
  },
}
