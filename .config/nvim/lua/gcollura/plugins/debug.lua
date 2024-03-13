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

return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text" },
		config = function()
			vim.keymap.set("n", "<leader>du", function()
				require("dapui").toggle()
			end)
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				vim.print("before attach")
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				vim.print("before launch")
				for type, _ in pairs(dap.configurations) do
					for _, config in pairs(dap.configurations[type]) do
						if config.envFile then
							local filePath = config.envFile
							for key, fn in pairs(var_placeholders) do
								filePath = filePath:gsub(key, fn)
							end
							for line in io.lines(filePath) do
								local words = {}
								for word in string.gmatch(line, "[^=]+") do
									table.insert(words, word)
								end
								if not config.env then
									config.env = {}
								end
								config.env[words[1]] = words[2]
							end
						end
					end
				end
				dapui.open()
			end
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			vim.keymap.set("n", "<leader>db", function()
				require("dap").toggle_breakpoint()
			end)
			vim.keymap.set("n", "<leader>dc", function()
				require("dap").continue()
			end)
			vim.keymap.set("n", "<leader>dso", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<leader>di", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<leader>do", function()
				require("dap").step_out()
			end)
			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.open()
			end)
			vim.keymap.set("n", "<Leader>dl", function()
				require("dap").run_last()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end)

			local dapgo = require("dap-go")
			vim.keymap.set("n", "<leader>dt", dapgo.debug_test)
			vim.keymap.set("n", "<leader>dl", dapgo.debug_last_test)
		end,
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = true,
	},
}
