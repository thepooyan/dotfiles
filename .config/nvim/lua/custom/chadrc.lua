---@type ChadrcConfig
local M = {}

local highlights = require "custom.highlights"

M.ui = {
  theme = "bearded-arc",
  theme_toggle = { "bearded-arc", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

local vim = vim
local opt = vim.opt

vim.keymap.set({ 'n', 'v' }, '<leader>]', ':Gen<CR>')
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99          -- Open all folds by default
opt.conceallevel = 2;
opt.showmode = false

return M
