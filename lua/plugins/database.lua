return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      vim.keymap.set('n', '<leader>db', '<cmd>DBUIToggle<cr>', { desc = "Toggle DBUI" })

      vim.g.db_ui_save_queries_state = 1
      vim.g.db_ui_show_database_icon = 1
    end,
  },
}
