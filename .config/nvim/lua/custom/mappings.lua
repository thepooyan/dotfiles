---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<C-h>"] = {"<cmd> TmuxNavigateLeft<cr>", "widnow left"},
    ["<C-l>"] = {"<cmd> TmuxNavigateRight<cr>", "widnow right"},
    ["<C-k>"] = {"<cmd> TmuxNavigateUp<cr>", "widnow up"},
    ["<C-j>"] = {"<cmd> TmuxNavigateDown<cr>", "widnow down"},
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

return M
