return {
	"echasnovski/mini.nvim",
	version = false,
	event = "VeryLazy",
	config = function()
		local spec_treesitter = require("mini.ai").gen_spec.treesitter
		require("mini.ai").setup({
			custom_textobjects = {
				F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
			},
		})
	end,
}
