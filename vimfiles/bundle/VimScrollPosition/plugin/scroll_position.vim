if exists("loaded_scroll_position_plugin")
  finish
endif
let loaded_scroll_position_plugin = 1

command! -nargs=0 ScrollPositionShow   call scroll_position#show()
command! -nargs=0 ScrollPositionHide   call scroll_position#hide()
command! -nargs=0 ScrollPositionToggle call scroll_position#toggle()

if get(g:, 'scroll_position_auto_enable', 1)
  call scroll_position#show()
end
