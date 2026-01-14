return {
  'nvim-java/nvim-java',
  config = function()
    require('java').setup()
    vim.lsp.enable('jdtls')

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "pom.xml",
      callback = function()
        local clients = vim.lsp.get_active_clients({ name = "jdtls" })
        if #clients > 0 then
          vim.lsp.buf.execute_command({ command = "java.project.updateConfig" })
          vim.notify("Maven project updated")
        end
      end,
    })
  end,
}
