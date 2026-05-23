return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "angularls", "vtsls" },
        automatic_enable = vim.fn.has("nvim-0.11") == 1,
      })

      if vim.fn.has("nvim-0.11") == 0 then
        local lspconfig = require("lspconfig")
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
          capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        lspconfig.angularls.setup({ capabilities = capabilities })
        lspconfig.vtsls.setup({ capabilities = capabilities })
      end
    end,
  },
}
