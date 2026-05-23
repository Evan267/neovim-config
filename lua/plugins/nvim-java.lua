return {
  'nvim-java/nvim-java',
  enabled = vim.fn.has('nvim-0.11.5') == 1,
  config = function()
    require('java').setup()

    if vim.lsp.enable then
      vim.lsp.enable('jdtls')
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "pom.xml",
      callback = function()
        local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
        local clients = get_clients({ name = "jdtls" })
        if #clients > 0 then
          vim.lsp.buf.execute_command({ command = "java.project.updateConfig" })
          vim.notify("Maven project updated")
        end
      end,
    })
  end,
}
