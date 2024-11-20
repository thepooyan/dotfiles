local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "tailwindcss-language-server",
    "emmet-ls",
    "eslint-lsp",
    "prettierd",
    "typescript-language-server",
    "js-debug-adapter",

    -- go
    "gopls",

    -- c/cpp stuff
    -- "clangd",
    -- "clang-format",

    -- python
    -- "pyright",
    -- "ruff",
    -- "mypy",
    -- "black",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  view = {
    side = "right",
  },
}

return M
