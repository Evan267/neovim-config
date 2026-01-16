vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Aller à la définition" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Aller aux implémentations" })
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = "Voir les références (Telescope)" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Afficher la documentation" })

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Renommer partout" })

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Actions de code" })

vim.keymap.set("n", "<leader>cr", function()
  local current_name = vim.fn.expand("<cword>")
  vim.lsp.buf.rename()
  
  vim.defer_fn(function()
    vim.cmd("wa")
    vim.notify("Renommage de '" .. current_name .. "' terminé (Code + Fichier)", "info")
  end, 500)
end, { desc = "Rename Class and Sync File" })
