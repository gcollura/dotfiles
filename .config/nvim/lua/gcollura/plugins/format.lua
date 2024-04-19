local function find_node_modules_bin_from_cur_buf(binary_name)
	return function()
		local nm_paths = vim.fs.find("node_modules", {
			upward = true,
			stop = vim.loop.os_homedir(),
			path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
		})
		for _, path in ipairs(nm_paths) do
			local local_binary = vim.fs.dirname(path) .. "/node_modules/.bin/" .. binary_name
			if vim.loop.fs_stat(local_binary) then
				return local_binary
			end
		end
		return binary_name
	end
end

return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			local parser = require("lint.parser")

			lint.linters_by_ft = {
				typescript = { "eslint" },
				typescriptreact = { "eslint" },
				javascript = { "eslint" },
				javascriptreact = { "eslint" },
				go = { "revive" },
				graphql = { "graphql_schema_linter" },
			}
			lint.linters.eslint.cmd = find_node_modules_bin_from_cur_buf("eslint")
			lint.linters.graphql_schema_linter = {
				cmd = find_node_modules_bin_from_cur_buf("graphql-schema-linter"),
				stdin = false,
				ignore_exitcode = true,
				args = {
					"--config-directory",
					"web/frontend/src/api/lint",
					"--format",
					"compact",
					function()
						return vim.fn.expand("%:p:h") .. "/*.graphqls"
					end,
				},
				parser = parser.from_pattern("^(.+):(%d+):(%d+) (.+)$", {
					"file",
					"lnum",
					"col",
					"message",
				}),
			}
			lint.linters.revive = {
				cmd = "revive",
				ignore_exitcode = true,
				stdin = false,
				args = { "-config", "revive.toml" },
				parser = parser.from_pattern("[^:]+:(%d+):(%d+): (.*)", { "lnum", "col", "message" }, nil, {
					["source"] = "revive",
				}),
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "Format" },
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "isort" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				graphql = { "prettier" },
				go = { "golines" },
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
			formatters = {
				golines = {
					prepend_args = { "--base-formatter=gofmt" },
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
		end,
		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
			end, { range = true })
		end,
	},
}
