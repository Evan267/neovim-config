return {
  'mrcjkb/rustaceanvim',
  version = '^7',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          local opts = { silent = true, buffer = bufnr }

          vim.keymap.set('n', '<leader>ca', function() vim.cmd.RustLsp('codeAction') end, { desc = "Rust: Code Action", buffer = bufnr })
          vim.keymap.set('n', 'K', function() vim.cmd.RustLsp('hover_actions') end, { desc = "Rust: Hover", buffer = bufnr })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Rust: Go to Definition", buffer = bufnr })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Rust: Go to Implementation", buffer = bufnr })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rust: Rename", buffer = bufnr })
          vim.keymap.set('n', '<leader>rr', function() vim.cmd.RustLsp('runnables') end, { desc = "Rust: Runnables", buffer = bufnr })
          vim.keymap.set('n', '<leader>rd', function() vim.cmd.RustLsp('debuggables') end, { desc = "Rust: Debuggables", buffer = bufnr })
          vim.keymap.set('n', '<leader>em', function() vim.cmd.RustLsp('expandMacro') end, { desc = "Rust: Expand Macro", buffer = bufnr })
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev Diagnostic", buffer = bufnr })
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic", buffer = bufnr })
        end,
      },
    }
  end
}
