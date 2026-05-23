vim.api.nvim_create_user_command("CreateModule", function(opts)
  local name = opts.args
  if name == "" then
    vim.notify("Un nom de module est requis", vim.log.levels.ERROR)
    return
  end

  local project = require("config.project")
  local angular = require("core.generators.angular")
  local rust = require("core.generators.rust")
  
  if project.is_angular() then
    angular.create_angular_module(name)
  elseif project.is_rust() then
    rust.create_rust_module(name)
  else
    vim.notify("Type de projet non supporté pour la génération automatique", vim.log.levels.WARN)
  end
end, {
  nargs = 1,
  desc = "Génère une architecture de module pour Angular ou Rust"
})
