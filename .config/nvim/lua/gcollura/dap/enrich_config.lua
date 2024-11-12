local M = {}

local var_placeholders = {
	["${file}"] = function(_)
		return vim.fn.expand("%:p")
	end,
	["${fileBasename}"] = function(_)
		return vim.fn.expand("%:t")
	end,
	["${fileBasenameNoExtension}"] = function(_)
		return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
	end,
	["${fileDirname}"] = function(_)
		return vim.fn.expand("%:p:h")
	end,
	["${fileExtname}"] = function(_)
		return vim.fn.expand("%:e")
	end,
	["${relativeFile}"] = function(_)
		return vim.fn.expand("%:.")
	end,
	["${relativeFileDirname}"] = function(_)
		return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
	end,
	["${workspaceFolder}"] = function(_)
		return vim.fn.getcwd()
	end,
	["${workspaceFolderBasename}"] = function(_)
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
	["${env:([%w_]+)}"] = function(match)
		return os.getenv(match) or ""
	end,
}

function M.enrich_config(config, on_config)
	local final_config = vim.deepcopy(config)

	if final_config.envFile then
		local filePath = final_config.envFile
		for key, fn in pairs(var_placeholders) do
			filePath = filePath:gsub(key, fn)
		end

		for line in io.lines(filePath) do
			local words = {}
			for word in string.gmatch(line, "[^=]+") do
				table.insert(words, word)
			end
			if not final_config.env then
				final_config.env = {}
			end
			final_config.env[words[1]] = words[2]
		end
	end

	on_config(final_config)
end

return M
