return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    tag = "v0.10.0",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
	"angular",
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
