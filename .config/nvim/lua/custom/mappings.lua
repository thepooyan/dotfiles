---@type MappingsTable
local M = {}

M.general = {
  n = {
    ["<C-h>"] = {"<cmd> TmuxNavigateLeft<cr>", "widnow left"},
    ["<C-l>"] = {"<cmd> TmuxNavigateRight<cr>", "widnow right"},
    ["<C-k>"] = {"<cmd> TmuxNavigateUp<cr>", "widnow up"},
    ["<C-j>"] = {"<cmd> TmuxNavigateDown<cr>", "widnow down"},

    ["<S-l>"] = {"f l", "jump forward by spaces"},
    ["<S-h>"] = {"F h", "jump backwards by spaces"},
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}
M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>fa"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>ff"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
  }
}

return M
