return {
  'rmagatti/auto-session',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
    { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
    { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
  },
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    mappings = {
      delete_session = { "i", "<C-d>" },
      alternate_session = { "i", "<C-s>" },
      copy_session = { "i", "<C-y>" },
    },
    auto_restore_enabled = true,
    auto_session_enable_last_session = false,
  }
}
