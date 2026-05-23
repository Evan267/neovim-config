return {
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons", "rcarriga/nvim-notify" },
    config = function()
      local oil = require("oil")
      local project = require("config.project")

      oil.setup({
        keymaps = {
          -- ["<leader>ac"] = { callback = handlers.angular.run_cli, desc = "Run Angular CLI" },
        },
        view_options = { show_hidden = true },
      })

      -- Autocmd pour déclencher smart_expand sur Enter en mode Insert
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "oil",
      --   callback = function()
      --     vim.keymap.set("i", "<CR>", function()
      --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      --       vim.defer_fn(smart_expand, 10)
      --     end, { buffer = true })
      --   end,
      -- })

      -- Keymaps de navigation rapide
      local map = vim.keymap.set
      map("n", "<leader>oi", "<CMD>Oil<CR>", { desc = "Open Oil" })
      map("n", "<leader>om", function()
        local path = project.get_modules_path()
        if path then oil.open(path) else print("No modules path found") end
      end, { desc = "Open Oil in Modules" })

      vim.keymap.set("n", "<leader>or", function()
	local path = project.get_resources_path()
	if path then
	  oil.open(path)
	else
	  print("No resources path defined for this project type")
	end
      end, { desc = "Open Oil in Resources" })

      vim.keymap.set("n", "<leader>op", function()
	oil.open(project.get_project_root())
      end, { desc = "Open Oil in Project Root" })
    end
  },
}
