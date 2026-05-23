local M = {}

function M.is_java_spring()
  local root = vim.fn.getcwd()
  return vim.fn.filereadable(root .. "/pom.xml") == 1 or vim.fn.filereadable(root .. "/build.gradle") == 1
end

function M.is_angular()
  return vim.fn.filereadable(vim.fn.getcwd() .. "/angular.json") == 1
end

function M.is_rust()
  return vim.fn.filereadable(vim.fn.getcwd() .. "/Cargo.toml") == 1
end

function M.is_java_dir(dir)
  return dir:match("src/main/java/") ~= nil or dir:match("src/test/java/") ~= nil
end

function M.get_java_package(dir)
  local auth_path = dir:match("src/main/java/(.+)$") or dir:match("src/test/java/(.+)$")
  if auth_path then
    return auth_path:gsub("/", "."):gsub("%.$", "")
  end
  return nil
end

function M.get_project_root()
  return vim.fs.dirname(vim.fs.find({'.git', 'pom.xml', 'angular.json', 'Cargo.toml'}, { upward = true })[1]) or vim.fn.getcwd()
end

function M.get_modules_path()
  local root = M.get_project_root()
  if M.is_angular() then
    return root .. "/src/app/modules"
  elseif M.is_rust() then
    return root .. "/src/"
  elseif M.is_java_spring() then
    local path = vim.fn.glob(root .. "/src/main/java/com/*/*/", true, true)[1]
    return path or (root .. "/src/main/java")
  end
  return nil
end

function M.get_resources_path()
  local root = M.get_project_root()
  if M.is_java_spring() then
    return root .. "/src/main/resources"
  elseif M.is_angular() then
    return root .. "/src/assets"
  end
  return nil
end

local function normalize_path(path)
  if not path then return nil end
  return vim.fn.fnamemodify(path, ":p:h")
end

function M.is_features_dir(path)
  local features_path = normalize_path(M.get_modules_path())
  local current_path = normalize_path(path)
  return features_path == current_path
end

function M.is_components_dir(path)
  local current_path = normalize_path(path)
  if not current_path then return false end
  return current_path:match("components$") ~= nil
end

function M.get_dir_name(path)
  return vim.fn.fnamemodify(path, ":p:h:t")
end

function M.is_angular_dir(path, name)
  if not M.is_angular() then return false end
  return M.get_dir_name(path) == name
end

function M.switch_to_ext(ext)
  if not M.is_angular() then return end

  local current_file = vim.fn.expand("%:p")
  local base_path = vim.fn.expand("%:p:r"):gsub("%.spec$", "")

  local style_extensions = { "scss", "css", "less" }
  local target

  if ext == "style" then
    -- On cherche lequel des fichiers de style existe
    for _, s_ext in ipairs(style_extensions) do
      local test_path = base_path .. "." .. s_ext
      if vim.fn.filereadable(test_path) == 1 then
        target = test_path
        break
      end
    end
  else
    target = base_path .. "." .. ext
  end

  if target and target ~= current_file and vim.fn.filereadable(target) == 1 then
    vim.cmd.edit(vim.fn.fnameescape(target))
  elseif target == current_file then
  else
    vim.notify("Fichier ." .. ext .. " introuvable", vim.log.levels.WARN)
  end
end

return M
