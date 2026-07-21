-- Finds the [start, end] line numbers (1-indexed, inclusive) of the
-- "paragraph" (contiguous non-blank block of lines) that `lnum` sits in.
local function get_paragraph_bounds(lines, lnum)
	local start_l = lnum
	while start_l > 1 and lines[start_l - 1] ~= "" do
		start_l = start_l - 1
	end

	local end_l = lnum
	local n = #lines
	while end_l < n and lines[end_l + 1] ~= "" do
		end_l = end_l + 1
	end

	return start_l, end_l
end

-- Looks for a block shaped like:
--   (
--     "domain.in",
--     Vector(
-- Returns the matched name (e.g. "domain.in") and the line index of the
-- opening "(" if found within [start_l, end_l].
local function find_domain_name(lines, start_l, end_l)
	for i = start_l, end_l - 2 do
		if lines[i]:match("^%s*%(%s*$") then
			local name = lines[i + 1]:match('^%s*"([^"]*)",%s*$')
			if name and lines[i + 2]:match("^%s*Vector%(%s*$") then
				return name, i
			end
		end
	end
	return nil, nil
end

-- Looks (within [start_l, end_l]) for an entry shaped like:
--     (
--       "<label>",
--       Vector(
--         ...
--       )
-- (which may also be fully collapsed onto a single "Vector(...)" line, and
-- may be empty) and returns everything inside the Vector(...) as a string.
local function find_vector_content(lines, start_l, end_l, label)
	for i = start_l, end_l do
		local name = lines[i]:match('^%s*"([^"]*)",%s*$')
		if name == label then
			local vec_line = i + 1
			if vec_line > end_l then
				return nil
			end

			-- Single-line case: Vector(...) fully on one line.
			local inline = lines[vec_line]:match("^%s*Vector%((.*)%)%s*$")
			if inline then
				return inline
			end

			-- Multi-line case: Vector( on its own line, contents until the
			-- matching closing ")" on its own line.
			if lines[vec_line]:match("^%s*Vector%(%s*$") then
				local content = {}
				local j = vec_line + 1
				while j <= end_l do
					if lines[j]:match("^%s*%)%s*$") then
						break
					end
					table.insert(content, lines[j])
					j = j + 1
				end
				return table.concat(content, "\n")
			end
		end
	end
	return nil
end

-- Searches (from the cursor, forward if `forward` is true / backward if
-- false) for the *next* "domain" block (always skipping past the paragraph
-- the cursor currently sits in), copies its name to the system clipboard,
-- and copies the contents of its "Missed Doms" Vector(...) into the unnamed
-- (yank) register.
--
-- If a line starting with "sbt:fpFinder>" is encountered before a domain
-- block is found, the cursor is moved there (and the window scrolled) and
-- the search stops without copying anything.
local function copyDomainInfo(id, forward)
	if not (id and vim.api.nvim_buf_is_valid(id)) then
		return
	end

	vim.api.nvim_buf_call(id, function()
		local lines = vim.api.nvim_buf_get_lines(id, 0, -1, false)
		local cur_lnum = vim.api.nvim_win_get_cursor(0)[1]

		local step = forward and 1 or -1
		local s, e = get_paragraph_bounds(lines, cur_lnum)
		local lnum = (forward and e or s) + step

		local name, block_start, block_end

		while lnum >= 1 and lnum <= #lines do
			local line = lines[lnum]

			if line:match("^sbt:fpFinder>") then
				vim.api.nvim_win_set_cursor(0, { lnum, 0 })
				vim.cmd("normal! zt")
				vim.notify("Reached sbt:fpFinder> prompt", vim.log.levels.INFO)
				return
			end

			if line == "" then
				lnum = lnum + step
			else
				local ps, pe = get_paragraph_bounds(lines, lnum)
				name = select(1, find_domain_name(lines, ps, pe))
				if name then
					block_start, block_end = ps, pe
					break
				end
				lnum = (forward and pe or ps) + step
			end
		end

		if not name then
			vim.notify("No domain block found", vim.log.levels.WARN)
			return
		end

		-- Move the cursor to the start of the matched paragraph and scroll it
		-- to the top of the window.
		vim.api.nvim_win_set_cursor(0, { block_start, 0 })
		vim.cmd("normal! zt")

		vim.fn.setreg("+", name)

		local vec_content = find_vector_content(lines, block_start, block_end, "Missed Doms")
		local count = 0
		if vec_content then
			vim.fn.setreg('"', vec_content)
			for _ in vec_content:gmatch('"[^"]*"') do
				count = count + 1
			end
		end

		vim.notify(
			("Copied domain %q to clipboard%s"):format(
				name,
				vec_content and (" and %d Missed Doms entries to yank register"):format(count) or ""
			)
		)
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
			copyDomainInfo(termRight.bufnr, false)
		end, { desc = "Copy domain name/Missed Doms (search backward)" })

		set("n", "<leader>pf", function()
			copyDomainInfo(termRight.bufnr, true)
		end, { desc = "Copy domain name/Missed Doms (search forward)" })

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

				local delay = 8000

				vim.defer_fn(function()
					if not termFloat:is_open() then
						termFloat:toggle()
					end
					termFloat:send("just all", false)
				end, delay)

				vim.defer_fn(function()
					lazygit:toggle()
				end, delay + 10000)
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
