return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = false,
	integrations = {
	  cmp = true,
	  gitsigns = true,
	  nvimtree= true,
	  treesitter = true,
	  notify = true,
	  mini = true,
	},
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  }
}
