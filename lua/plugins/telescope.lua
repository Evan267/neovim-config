return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      local builtin = require('telescope.builtin')

      require('telescope').setup({
	defaults = {
	  file_ignore_patterns = { ".git" },
	  preview = {
	    treesitter = false,
	  },
	}
      })

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Find Git files' })
      vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Find Text' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
    end
  }
}
