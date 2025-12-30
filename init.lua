local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
	})
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
