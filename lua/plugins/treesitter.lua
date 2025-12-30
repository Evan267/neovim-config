return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- On prend la dernière version
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" }, -- On remplace LazyFile par des événements standards
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "typescript",
        "java",
        "html",
        "css",
        "json",
        "yaml",
        "sql",
      },
    },
  },
}
