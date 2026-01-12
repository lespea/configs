local function moveWin(id, dir)
	if not (id and vim.api.nvim_buf_is_valid(id)) then
		return
	end

	local count = vim.v.count1

	vim.api.nvim_buf_call(id, function()
		vim.cmd(("normal! %d%szt"):format(count, dir))
	end)
end

return {
	"akinsho/toggleterm.nvim",
	dependencies = {
		"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
	},
	init = function()
		local events = require("neo-tree.events")

		require("toggleterm").setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			persist_size = true,
			on_close = function()
				events.fire_event(events.GIT_EVENT)
			end,
		})

		local term = require("toggleterm.terminal").Terminal

		local lazygit = term:new({ cmd = "lazygit", hidden = true, direction = "float" })
		local termFloat = term:new({ hidden = true, direction = "float" })
		local termRight = term:new({ hidden = true, direction = "vertical", newline_chr = "" })

		-- Expose terminals globally for use in other configs (like edgy)
		_G.my_terminals = {
			lazygit = lazygit,
			float = termFloat,
			right = termRight,
		}

		local ui = require("toggleterm.ui")
		local set = vim.keymap.set

		set("n", "<leader>pb", function()
			moveWin(termRight.bufnr, "{")
		end, { desc = "Scroll the right term back" })

		set("n", "<leader>pf", function()
			moveWin(termRight.bufnr, "}")
		end, { desc = "Scroll the right term forward" })

		for _, key in ipairs({ "<C-.>", "\\tt" }) do
			set({ "n", "t" }, key, function()
				termFloat:toggle()
			end, { desc = "Toggle floating terminal" })
		end

		for _, key in ipairs({ "<C-g>", "\\tg" }) do
			set({ "n", "t" }, key, function()
				lazygit:toggle()
				events.fire_event(events.GIT_EVENT)
			end, { desc = "Toggle lazygit" })
		end

		for _, key in ipairs({ "<C-'>", "\\tv" }) do
			set({ "n", "t" }, key, function()
				termRight:toggle()
			end, { desc = "Toggle vertical terminal" })
		end

		set({ "n", "t" }, "<S-Esc>", "<C-\\><C-n>")

		local save = function()
			vim.api.nvim_command([[update]])
		end

		local rightTerm = function()
			if termRight:is_open() then
				if termRight:is_focused() then
					ui:goto_previous()
				else
					save()
					termRight:focus()
				end
			else
				save()
				termRight:toggle()
			end
		end

		set({ "n" }, "<leader>ct", function()
			termRight:close()
			termRight = term:new({ hidden = true, direction = "vertical" })
		end)

		local function clearAndRun(cmd)
			return "" .. cmd .. "\n"
		end

		-- Persistent right term
		for _, key in ipairs({ "<C-,>", "\\tr" }) do
			set({ "n", "t" }, key, rightTerm)
		end

		set({ "n" }, "<leader>tc", function()
			if termRight:is_open() then
				termRight:send("", true)
			end
		end, { desc = "clear terminal" })

		set({ "n" }, "<leader>rf", function()
			if termRight:is_open() then
				termRight:send(clearAndRun("project fpFinder;run"), true)
			end
		end, { desc = "run fpFinder" })

		set({ "n" }, "<leader>rl", function()
			if termRight:is_open() then
				termRight:send(clearAndRun("\x1b[A"), true)
			end
		end, { desc = "run last cmd" })

		set({ "n" }, "<leader>rj", function()
			if termRight:is_open() then
				termRight:send(clearAndRun("just"), true)
			end
		end, { desc = "run just" })

		set({ "n" }, "<leader>ri", function()
			if termRight:is_open() then
				termRight:send(clearAndRun("just lint"), true)
			end
		end, { desc = "run just lint" })

		set({ "n" }, "<leader>rg", function()
			if termRight:is_open() then
				termRight:send(clearAndRun("project genLists;run;project fpFinder"), true)

				local delay = 5000

				vim.defer_fn(function()
					if not termFloat:is_open() then
						termFloat:toggle()
					end
					termFloat:send("just alln", false)
				end, delay)

				vim.defer_fn(function()
					lazygit:toggle()
				end, delay + 17000)
			end
		end, { desc = "run gen rules" })

		set({ "n" }, "<leader>rs", function()
			if not termRight:is_open() then
				termRight:open()
			end

			termRight:send(clearAndRun("sbt"), true)
		end, { desc = "run sbt" })
	end,
}
