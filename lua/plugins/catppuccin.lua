return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      local theme = require("config.theme")
      theme.apply()
      theme.setup_auto_sync()
    end,
  }
}
