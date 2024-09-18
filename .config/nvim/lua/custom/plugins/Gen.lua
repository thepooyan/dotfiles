return {
	"David-Kunz/gen.nvim",
  event = "VeryLazy",
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
			init = function()
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
}
