require('hop').setup()local b=require('vimp')b.bind('n','f',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.AFTER_CURSOR,current_line_only=false})end)b.bind('n','F',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.BEFORE_CURSOR,current_line_only=false})end)b.bind('o','f',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.AFTER_CURSOR,current_line_only=true,inclusive_jump=true})end)b.bind('o','F',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.BEFORE_CURSOR,current_line_only=true,inclusive_jump=true})end)b.bind('o','t',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.AFTER_CURSOR,current_line_only=true})end)b.bind('o','T',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.BEFORE_CURSOR,current_line_only=true})end)b.bind('no',',,f',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.AFTER_CURSOR,current_line_only=false,inclusive_jump=true})end)b.bind('no',',,F',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.BEFORE_CURSOR,current_line_only=false,inclusive_jump=true})end)b.bind('no',',,t',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.AFTER_CURSOR,current_line_only=false})end)b.bind('no',',,T',function()return require('hop').hint_char1({direction=require('hop.hint').HintDirection.BEFORE_CURSOR,current_line_only=false})end)b.bind('no',',,h',function()return require('hop').hint_char2()end)return true