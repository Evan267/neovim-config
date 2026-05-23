local M = {}

local function touch(path)
  local file = io.open(path, "a") -- "a" pour ne pas écraser si existe déjà
  if file then file:close() end
end

function M.create_rust_module(module_name)
  local project = require("config.project")
  local features_path = project.get_modules_path()
  if not features_path then return end

  local module_root = features_path .. "/" .. module_name

  -- Liste des chemins complets à créer
  local paths = {
    "application/dtos",
    "application/usecases/usecases_impl",
    "presentation/graphql",
    "presentation/models",
    "domain/aggregate",
    "domain/errors",
    "domain/events",
    "domain/ports/input",
    "domain/ports/output",
    "domain/repositories",
    "infrastructure",
  }

  -- Création du fichier racine du module (ex: src/features/auth.rs)
  touch(module_root .. ".rs")
  vim.fn.mkdir(module_root, "p")

  for _, path in ipairs(paths) do
    local parts = {}
    local current_base = module_root
    
    -- On découpe le chemin pour créer chaque parent avec son fichier .rs
    for part in path:gmatch("[^/]+") do
      table.insert(parts, part)
      local full_dir_path = module_root .. "/" .. table.concat(parts, "/")
      
      -- Crée le dossier
      vim.fn.mkdir(full_dir_path, "p")
      -- Crée le fichier .rs correspondant (ex: application.rs au niveau de application/)
      touch(full_dir_path .. ".rs")
    end
  end

  vim.notify("🦀 Module Rust '" .. module_name .. "' généré (Modern Layout)")
end

return M
