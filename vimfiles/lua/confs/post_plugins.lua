local vimp = require('vimp')
vimp.add_chord_cancellations('n', '<leader>')
vimp.map_command("ShowAllMaps", function(...)
	return vimp.show_maps('', ...)
end)
return vimp.map_command("ShowMaps", function(...)
	return vimp.show_maps(...)
end)
