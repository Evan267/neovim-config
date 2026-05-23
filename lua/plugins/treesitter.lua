return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'windwp/nvim-ts-autotag'
    },
    opts = {
      ensure_installed = { "java", "xml", "lua", "vim", "html", "angular", "css", "scss" },
      highlight = { enable = true },
    },
    config = function(_, opts)
      local status, ts_configs = pcall(require, "nvim-treesitter.configs")
      if status then
        ts_configs.setup(opts)
      else
        require("nvim-treesitter").setup(opts)
      end
      require('nvim-ts-autotag').setup({
	opts = {
	  enable_close = true,
	  enable_rename = true,
	  enable_close_on_slash = true,
	},
	per_filetype = {
	  ["xml"] = {
	    enable_close = true
	  }
	}
      })
    end,
  },
}
