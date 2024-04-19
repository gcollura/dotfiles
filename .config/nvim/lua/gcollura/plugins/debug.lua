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
		dependencies = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()

			vim.keymap.set("n", "<leader>de", function()
				dapui.eval()
			end, { desc = "DAP UI eval" })
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "Toggle DAP UI" })

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
			local dap, dapgo = require("dap"), require("dap-go")
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, { desc = "Continue debugging" })
			vim.keymap.set("n", "<leader>ds", function()
				dap.step_over()
			end, { desc = "Step over" })
			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, { desc = "Step into" })
			vim.keymap.set("n", "<leader>do", function()
				dap.step_out()
			end, { desc = "Step out" })
			vim.keymap.set("n", "<Leader>dr", function()
				dap.repl.open()
			end, { desc = "Open REPL" })
			vim.keymap.set("n", "<Leader>dl", function()
				dap.run_last()
			end, { desc = "Run last" })
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Debug hover" })
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end, { desc = "Debug preview" })

			vim.keymap.set("n", "<leader>dt", dapgo.debug_test, { desc = "Debug test" })
			vim.keymap.set("n", "<leader>dT", dapgo.debug_last_test, { desc = "Debug last test" })
		end,
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = true,
	},
}
