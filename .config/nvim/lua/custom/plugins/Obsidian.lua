return {
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
			{
				name = "Board",
				path = "/home/pooyan/.Board/",
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
}
