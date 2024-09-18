local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- web dev
  null_ls.builtins.formatting.prettierd,

  -- python
  null_ls.builtins.diagnostics.mypy,
  null_ls.builtins.diagnostics.ruff,
  null_ls.builtins.formatting.black,
}

null_ls.setup {
  sources = sources,
}
