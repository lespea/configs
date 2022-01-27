require('hop').setup()
local vimp = require('vimp');
vimp.bind('no', 'f', function()
	return require('hop').hint_char1({
		direction = require('hop.hint').HintDirection.AFTER_CURSOR,
		current_line_only = false,
		inclusive_jump = false
	})
end);
vimp.bind('no', 'F', function()
	return require('hop').hint_char1({
		direction = require('hop.hint').HintDirection.AFTER_CURSOR,
		current_line_only = false,
		inclusive_jump = true
	})
end);
vimp.bind('no', 't', function()
	return require('hop').hint_char1({
		direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
		current_line_only = false,
		inclusive_jump = false
	})
end);
vimp.bind('no', 'T', function()
	return require('hop').hint_char1({
		direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
		current_line_only = false,
		inclusive_jump = true
	})
end)
return true
