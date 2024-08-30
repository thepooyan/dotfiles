local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	{
		lazy = false,
		"Pocco81/auto-save.nvim",
		opts = {
			{
				enabled = true,
				execution_message = {
					message = function()
						return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
					end,
					dim = 0.18,
					cleaning_interval = 1250,
				},
				trigger_events = { "InsertLeave", "TextChanged" },
				condition = function(buf)
					local fn = vim.fn
					local utils = require("auto-save.utils.data")

					if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
						return true
					end
					return false
				end,
				write_all_buffers = false,
				debounce_delay = 135,
				callbacks = {
					enabling = nil,
					disabling = nil,
					before_asserting_save = nil,
					before_saving = nil,
					after_saving = nil,
				},
			},
		},
	},
	{
		lazy = false,
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},
	{
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
	},
	{
		"David-Kunz/gen.nvim",
		lazy = false,
		config = function()
			local gen = require("gen")
			gen.setup({
				model = "phi3:mini",
				quit_map = "q",
				retry_map = "<c-r>",
				accept_map = "<c-cr>",
				host = "localhost",
				port = "11434",
				display_mode = "float",
				show_prompt = false,
				show_model = false,
				no_auto_close = false,
				hidden = false,
				init = function(options)
					pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
				end,
				command = function(options)
					return "curl --silent --no-buffer -X POST http://"
						.. options.host
						.. ":"
						.. options.port
						.. "/api/chat -d $body"
				end,
				debug = false,
			})
			gen.prompts["Generate"] = {
				prompt = "Generate a code that does this '$input'. don't write any comments, and don't explain anyting, and don't test the code after you write it. Only ouput the result in this format:```ts\n...\n```",
				extract = "```typescript\n(.-)```",
				replace = true,
			}
		end,
	},

	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_host_cmd = "echo http://127.0.0.1:11434",
				api_key_cmd = 'echo -n "a"',
				openai_params = {
					model = "codellama:7b",
					frequency_penalty = 0,
					presence_penalty = 0,
					max_tokens = 300,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
				openai_edit_params = {
					model = "codellama:7b",
					frequency_penalty = 0,
					presence_penalty = 0,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	-- vim tumux navigator
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		opts = function()
			return require("custom.configs.null-ls")
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		opts = {
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "nvim_lua" },
				{ name = "path" },
				{ name = "cmp_tabnine" },
			},
		},

		dependencies = {
			{
				"tzachar/cmp-tabnine",
				build = "./install.sh",
				config = function()
					local tabnine = require("cmp_tabnine.config")
					tabnine:setup({
						max_lines = 1000,
						max_num_results = 20,
						sort = true,
						run_on_every_keystroke = true,
						snippet_placeholder = "..",
						ignored_file_types = {
							-- default is not to ignore
							-- uncomment to ignore in lua:
							-- lua = true
						},
						show_prediction_strength = false,
						min_percent = 0,
					}) -- put your options here
				end,
			},
		},
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }

	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "Documentation",
					path = "/home/pooyan/0 Pooyan/Obsidian/Documentation/",
				},
				{
					name = "mini",
					path = "/home/pooyan/0 Pooyan/Obsidian/mini/",
				},
				{
					name = "Brain",
					path = "/home/pooyan/0 Pooyan/Obsidian/Brain/",
				},
				{
					name = "Thoughts",
					path = "/home/pooyan/0 Pooyan/Obsidian/Thoughts",
				},
				{
					name = "VHG",
					path = "/home/pooyan/0 Pooyan/Obsidian/VGH/",
				},
				{
					name = "NOTES",
					path = "/home/pooyan/0 Pooyan/Obsidian/NOTES/",
				},
			},
			new_notes_location = "current_dir",

			---@param title string|?
			---@return string
			note_id_func = function(title)
				return title or ""
			end,
			-- Optional, alternatively you can customize the frontmatter data.
			---@return table
			note_frontmatter_func = function(note)
				-- Add the title of the note as an alias.
				if note.title then
					note:add_alias(note.title)
				end

				local currentDate = os.date("%Y-%m-%d")
				local currentTime = os.date("%H:%M")

				local out = { name = note.id, date = currentDate, time = currentTime }

				-- `note.metadata` contains any manually added fields in the frontmatter.
				-- So here we just make sure those fields are kept in the frontmatter.
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end

				return out
			end,
		},
	},
}

return plugins
