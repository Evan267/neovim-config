local project = require("config.project")

local M = {}

-- Fonction pour lancer le CLI Angular (ng g ...)
function M.run_cli()
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
      })
    end
  end)
end

-- Fonction pour l'expansion automatique (smart_expand)
function M.handle(current_dir, line_content)
  local name = line_content:gsub("/", "")
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

function M.create_angular_module(module_name)
  if not M.is_angular() then
    return
  end

  local features_path = M.get_modules_path()
  if not features_path then
    vim.notify("Dossier features introuvable", vim.log.levels.ERROR)
    return
  end

  -- Construction du chemin de base du module
  local module_root = features_path .. "/" .. module_name

  -- Définition de l'arborescence
  local structure = {
    "application/usecases/usecases_impl",
    "application/dtos",
    "presentation/resolvers",
    "presentation/pages",
    "presentation/components",
    "domain/model",
    "domain/ports/in",
    "domain/ports/out",
    "domain/repositories",
    "domain/services",
    "infrastructure/graphql/models",
    "infrastructure/graphql/requests",
    "infrastructure/schema",
  }

  -- Création des dossiers
  for _, subdir in ipairs(structure) do
    local full_path = module_root .. "/" .. subdir
    -- 'p' permet de créer les parents si inexistants (équivalent à mkdir -p)
    vim.fn.mkdir(full_path, "p")
  end

  vim.notify("📦 Module '" .. module_name .. "' créé avec succès dans modules/", vim.log.levels.INFO)
end

return M
