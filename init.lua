local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
	})
end

if os.getenv('WEZTERM_PANE') then
    vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
        group = vim.api.nvim_create_augroup('WeztermSetUserVar', { clear = true }),
        callback = function()
            io.stdout:write("\x1b]1337;SetUserVar=IS_NVIM=dHJ1ZQ==\x07") -- "true" en base64
        end,
    })
    vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
        group = vim.api.nvim_create_augroup('WeztermUnsetUserVar', { clear = true }),
        callback = function()
            io.stdout:write("\x1b]1337;SetUserVar=IS_NVIM=ZmFsc2U=\x07") -- "false" en base64
        end,
    })
end

vim.notify = function(msg, log_level, _opts)
  if msg:match("deprecated") or msg:match("Feature will be removed") then
    return
  end
  return vim.api.nvim_echo({{msg}}, true, {})
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local luarocks_path = vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
local luarocks_cpath = vim.fn.expand("$HOME") .. "/.luarocks/lib/lua/5.1/?.so;"
package.path = package.path .. ";" .. luarocks_path
package.cpath = package.cpath .. ";" .. luarocks_cpath

require("lazy").setup("plugins")

require("config.options")
require("config.utils")
require("config.keymaps")
