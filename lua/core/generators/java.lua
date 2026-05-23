local oil = require("oil")
local project = require("config.project")

local M = {}

function M.handle(current_dir, line_content, force_choice)
  if not project.is_java_dir(current_dir) or line_content:match("/$") then
    return false
  end

  local name = line_content:gsub("/", "")
  local package = project.get_java_package(current_dir)
  if not package then return false end

  -- Si on est en headless, on utilise force_choice ou "class" par défaut
  if vim.g.is_headless or #vim.api.nvim_list_uis() == 0 then
    M.create_java_file(current_dir, name, package, force_choice or "class")
    return true
  end

  -- Sinon, on garde le vim.ui.select actuel...
  vim.ui.select({ "class", "interface", "record", "enum", "annotation" }, {
    prompt = "Type Java:",
  }, function(choice)
    if choice then M.create_java_file(current_dir, name, package, choice) end
  end)
  return true
end

function M.create_java_file(current_dir, name, package, choice)
  local filepath = current_dir .. name .. ".java"
  local lines = { "package " .. package .. ";", "", "public " .. choice .. " " .. name .. " {", "", "}" }
  vim.fn.writefile(lines, filepath)
  print("☕ Java " .. choice .. " générée : " .. name)
end

return M
