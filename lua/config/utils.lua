local function run_in_wezterm_split(cmd)
  local full_cmd = string.format(
    "wezterm cli split-pane --right --percent 25 -- bash -c \"%s; echo '--- Appuyez sur Entrée pour fermer ---'; read\"",
    cmd
  )
  os.execute(full_cmd)
end

vim.keymap.set('n', '<leader>ns', function()
  run_in_wezterm_split("npm run start")
end, { desc = "Npm run start" })

vim.keymap.set('n', '<leader>ms', function()
  run_in_wezterm_split("mvn spring-boot:run")
end, { desc = "Maven Spring Run"})
