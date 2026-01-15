return {
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons", "rcarriga/nvim-notify" },
    config = function()
      local oil = require("oil")
      local project = require("config.project")

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
                  oil.discard_all_changes()
                end
              end
            })
          end
        end)
      end

      local function generate_angular_item(current_dir, name)
	local dir_name = project.get_dir_name(current_dir)

	local rules = {
	  containers = "ng g c %s --inline-style --inline-template",
	  presenters = "ng g c %s",
	  guards     = "ng g guard %s",
	  services   = "ng g s %s",
	}

	local cmd_template = rules[dir_name]
	if not cmd_template then return false end

	local final_cmd = string.format(cmd_template, name)

	vim.notify("🚀 " .. final_cmd)
	vim.fn.jobstart(final_cmd, {
	  cwd = current_dir,
	  on_exit = function(_, code)
	    if code == 0 then
	      vim.notify("✅ " .. name .. " généré")
	      oil.discard_all_changes()
	    else
	      vim.notify("❌ Erreur ng g", vim.log.levels.ERROR)
	    end
	  end
	})
	return true
      end

      local function generate_java_item(current_dir, name)
	local package = project.get_java_package(current_dir)
	if not package then return false end

	vim.ui.select({ "class", "interface", "record", "enum", "annotation" }, {
	  prompt = "Type de fichier Java pour '" .. name .. "':",
	}, function(choice)
	  if not choice then return end

	  local filename = name .. ".java"
	  local filepath = current_dir .. filename

	  local lines = {
	    "package " .. package .. ";",
	    "",
	    "public " .. choice .. " " .. name .. " {",
	    "",
	    "}",
	  }

	  if choice == "record" then
	    lines[3] = "public " .. choice .. " " .. name .. "() {"
	  end

	  vim.fn.writefile(lines, filepath)
	  oil.discard_all_changes()
	  vim.defer_fn(function()
	    vim.cmd("edit " .. filepath)
	  end, 50)
	end)

	return true
      end

      local function smart_expand()
	local line = vim.api.nvim_get_current_line()
	local current_dir = oil.get_current_dir()
	if not current_dir then return end

	local item_name = line:gsub("/", "")
	if item_name == "" then return end

	local was_angular = generate_angular_item(current_dir, item_name)
	if was_angular then return end

	if project.is_java_dir(current_dir) and not line:match("/$") then
	  generate_java_item(current_dir, item_name)
	  return
	end

	local slash_count = select(2, line:gsub("/", ""))
	if line:match("/$") and slash_count == 1 then
	  local subdirs = {}
	  if project.is_features_dir(current_dir) then
	    subdirs = { "application/", "domain/", "infrastructure/", "presentation/" }
	  elseif project.is_components_dir(current_dir) then
	    subdirs = { "containers/", "presenters/" }
	  end

	  if #subdirs > 0 then
	    local lines_to_insert = {}
	    for _, sub in ipairs(subdirs) do
	      table.insert(lines_to_insert, item_name .. "/" .. sub)
	    end
	    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	    vim.api.nvim_buf_set_lines(0, row, row, false, lines_to_insert)
	    vim.api.nvim_buf_set_lines(0, row-1, row, false, {})
	  end
	end
      end

      vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
	  vim.keymap.set("i", "<CR>", function()
	    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	    vim.defer_fn(function()
	      smart_expand()
	    end, 10)
	  end, { buffer = true, desc = "Expand Clean Arch on Enter" })
	end,
      })

      oil.setup({
	keymaps = {
	  ["<leader>ac"] = { callback = run_angular_cli, desc = "Run Angular CLI" },
	},
	view_options = { show_hidden = true },
      })

      vim.keymap.set("n", "<leader>oi", "<CMD>Oil<CR>", { desc = "Open Oil" })

      vim.keymap.set("n", "<leader>of", function()
	local path = project.get_features_path()
	if path then
	  oil.open(path)
	else
	  print("Not a Java or Angular project")
	end
      end, { desc = "Open Oil in Features" })

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
