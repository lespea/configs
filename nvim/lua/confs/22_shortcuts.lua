local set = vim.keymap.set

local optRS = {
	silent = true,
}

local optES = {
	noremap = false,
	expr = true,
	silent = true,
}

local optR = {}

-- Helper function to merge options with desc
local function opts_with_desc(base_opts, desc)
	local result = vim.tbl_extend("force", base_opts, { desc = desc })
	return result
end

set("n", "Q", "gqap", opts_with_desc(optRS, "Format paragraph"))

-- Cleanup
set("n", "<F9>", ":StripWhitespace<CR>", opts_with_desc(optR, "Strip whitespace"))
set("n", "<F10>", ":set expandtab<CR>:retab<CR>", opts_with_desc(optR, "Convert tabs to spaces"))

-- Buffs / Tabs
--set('n', '<A-l>', ':tabnext<CR>', optRS)
--set('n', '<A-h>', ':tabprevious<CR>', optRS)
set("n", "<C-t>", ":tabnew<CR>", opts_with_desc(optRS, "New tab"))

-- Windows
set("n", "<C-n>", "h", opts_with_desc(optRS, "Move left"))
set("n", "<C-j>", "j", opts_with_desc(optRS, "Move down"))
set("n", "<C-k>", "k", opts_with_desc(optRS, "Move up"))
set("n", "<C-m>", "l", opts_with_desc(optRS, "Move right"))
set("n", "<C-p>", "", opts_with_desc(optRS, "Noop"))

-- Copy/Paste
set("n", "<C-S-V>", '"+p', opts_with_desc(optR, "Paste from system clipboard"))
set("v", "<C-S-C>", '"+y', opts_with_desc(optR, "Copy to system clipboard"))
set("v", "<leader>cy", '"+y', opts_with_desc(optR, "Copy to system clipboard"))
set("n", "<leader>cq", '"+yi"', opts_with_desc(optR, "Copy inside quotes to clipboard"))
set({ "n", "v" }, "<leader>cp", '"+p', opts_with_desc(optR, "Paste from system clipboard"))

-- Misc
set("v", ",u", ":Sort u<CR>", opts_with_desc(optRS, "Sort unique (visual selection)"))
set("n", ",u", "vib:Sort u<CR>", opts_with_desc(optRS, "Sort unique (inside parens)"))
set("n", ",U", "viB:Sort u<CR>", opts_with_desc(optRS, "Sort unique (inside braces)"))
set("n", "\\u", ":sort u<CR>:g/^$/d<CR>", opts_with_desc(optRS, "Sort unique and remove empty lines"))
set("n", "cd", ":cd %:p:h<CR>", opts_with_desc(optR, "Change directory to current file"))

-- Easy quit all
set("n", "\\qa", ":qa!<CR>", opts_with_desc(optRS, "Quit all without saving"))

-- Deal with wrapped lines
set("n", "k", "v:count == 0 ? 'gk' : 'k'", opts_with_desc(optES, "Move up (display line)"))
set("n", "j", "v:count == 0 ? 'gj' : 'j'", opts_with_desc(optES, "Move down (display line)"))

-- resize up and down
set("n", ";k", ":resize +3 <CR>", opts_with_desc(optRS, "Increase window height"))
set("n", ";j", ":resize -3 <CR>", opts_with_desc(optRS, "Decrease window height"))

-- resize right and left
set("n", ";l", ":vertical resize +3 <CR>", opts_with_desc(optRS, "Increase window width"))
set("n", ";h", ":vertical resize -3 <CR>", opts_with_desc(optRS, "Decrease window width"))

--[[
      easier moving of code blocks
      Try to go into visual mode (v), thenselect several lines of code
      here and then press ``>`` several times.
--]]
set("v", "<", "<gv", opts_with_desc(optRS, "Indent left (keep selection)"))
set("v", ">", ">gv", opts_with_desc(optRS, "Indent right (keep selection)"))

set("x", "p", function()
	return 'pgv"' .. vim.v.register .. "y"
end, { remap = false, expr = true, desc = "Paste without losing register" })

local function maximize()
	-- Get the editor dimensions
	local width = vim.o.columns
	local height = vim.o.lines

	-- Define margins
	local width_margin = 5 -- margins on left and right sides
	local height_margin = 2.5 -- margins on top and bottom

	-- Calculate window dimensions
	local win_width = width - (2 * width_margin)
	local win_height = height - (2 * height_margin)

	-- Calculate position for centering
	local row = height_margin
	local col = width_margin

	-- Open the floating window with the current buffer
	vim.api.nvim_open_win(0, true, {
		relative = "editor",
		row = row,
		col = col,
		width = win_width,
		height = win_height,
	})
end

-- set keymap
vim.keymap.set("n", "<C-W>z", maximize, { desc = "Maximize current buffer in a floating window" })

return true
