local function t()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local ts = require("nvim-treesitter.query")

	local current_node = ts_utils.get_node_at_cursor()

	if not current_node then
		return
	end

	local sibling = current_node:next_named_sibling()
	local parent = ts_utils.get_root_for_node(current_node)
	print("current_node:", current_node:type())
	print("parent:", parent:type())
	if sibling then
		print("sibling:", sibling:type())
	end
end

t()

local n = 10
