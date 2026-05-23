local M = {}

local state = {
  current_mode = nil,
  timer = nil,
}

local function is_wsl()
  if vim.fn.has("wsl") == 1 then
    return true
  end

  local version_file = io.open("/proc/version", "r")
  if not version_file then
    return false
  end

  local version = version_file:read("*a"):lower()
  version_file:close()

  return version:find("microsoft", 1, true) ~= nil or version:find("wsl", 1, true) ~= nil
end

local function command_output(command)
  if vim.fn.executable(command[1]) ~= 1 then
    return nil
  end

  local output = vim.fn.systemlist(command)
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return table.concat(output, "\n")
end

local function windows_apps_use_light_theme()
  if not is_wsl() then
    return nil
  end

  local reg_output = command_output({
    "reg.exe",
    "query",
    "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
    "/v",
    "AppsUseLightTheme",
  })

  if reg_output then
    local value = reg_output:match("AppsUseLightTheme%s+REG_DWORD%s+0x([01])")
    if value then
      return value == "1"
    end
  end

  local powershell_output = command_output({
    "powershell.exe",
    "-NoProfile",
    "-NonInteractive",
    "-Command",
    "(Get-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize').AppsUseLightTheme",
  })

  if powershell_output then
    local value = powershell_output:match("[01]")
    if value then
      return value == "1"
    end
  end

  return nil
end

function M.mode()
  local use_light_theme = windows_apps_use_light_theme()

  if use_light_theme == nil then
    return "dark"
  end

  return use_light_theme and "light" or "dark"
end

function M.catppuccin_flavour()
  return M.mode() == "light" and "latte" or "mocha"
end

function M.apply()
  local mode = M.mode()

  if state.current_mode == mode and vim.g.colors_name == "catppuccin" then
    return
  end

  state.current_mode = mode
  vim.o.background = mode

  local ok, catppuccin = pcall(require, "catppuccin")
  if ok then
    catppuccin.setup({
      flavour = mode == "light" and "latte" or "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = true,
      },
    })
  end

  vim.cmd.colorscheme("catppuccin")

  local has_lualine, lualine = pcall(require, "lualine")
  if has_lualine then
    lualine.refresh()
  end
end

function M.setup_auto_sync()
  local group = vim.api.nvim_create_augroup("WindowsThemeSync", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained", "VimResume" }, {
    group = group,
    callback = M.apply,
  })

  if state.timer then
    state.timer:stop()
    state.timer:close()
  end

  state.timer = (vim.uv or vim.loop).new_timer()
  state.timer:start(15000, 15000, vim.schedule_wrap(M.apply))

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if state.timer then
        state.timer:stop()
        state.timer:close()
        state.timer = nil
      end
    end,
  })

  vim.api.nvim_create_user_command("ThemeSync", M.apply, {})
end

return M
