return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()

			vim.keymap.set("n", "<leader>de", function()
				dapui.eval()
			end, { desc = "DAP UI eval" })
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "Toggle DAP UI" })

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
		end,
	},
}
