return {
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons", "rcarriga/nvim-notify" },
    config = function()
      local oil = require("oil")

      local run_angular_cli = function()
        local entry = oil.get_cursor_entry()
        local dir = oil.get_current_dir()
        if not entry or not dir then return end
        
        local actual_target = (entry.type == "directory") and (dir .. entry.name) or dir

        vim.ui.input({ prompt = "ng g " }, function(input)
          if input and input ~= "" then
            local full_cmd = string.format("cd '%s' && ng g %s", actual_target, input)
            
            vim.fn.jobstart(full_cmd, {
              stdout_buffered = true,
              on_stdout = function(_, data)
                if data and #data > 1 then
                  vim.notify(table.concat(data, "\n"), "success", { title = "Angular CLI - Succès" })
                end
              end,
              on_stderr = function(_, data)
                if data and #data > 1 and data[1] ~= "" then
                  vim.notify(table.concat(data, "\n"), "error", { title = "Angular CLI - Erreur" })
                end
              end,
              on_exit = function(_, code)
                if code == 0 then
                  require("oil").discard_all_changes()
                end
              end
            })
          end
        end)
      end

      oil.setup({
        keymaps = {
          ["<leader>ac"] = { callback = run_angular_cli, desc = "Run Angular CLI" },
        },
        view_options = { show_hidden = true },
      })

      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil" })
    end
  },
}
