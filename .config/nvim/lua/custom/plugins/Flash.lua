	return {
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			jump = {
				autojump = false,
			},
			label = {
				uppercase = false,
				style = "inline",
				rainbow = {
					enabled = false,
					shade = 3,
				},
			},
			highlight = {
				backdrop = true,
				matches = false,
			},
			modes = {
				char = {
					highlight = { backdrop = false },
				},
			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	}
