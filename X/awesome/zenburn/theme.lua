-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

local home = os.getenv("HOME")

-- {{{ Main
theme = {}
theme.wallpaper_cmd = { "awsetbg " .. home ..  "/.config/awesome/wallpaper.jpg" }
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.fg_normal = "#DCDCCC"
theme.fg_focus  = "#3F3F3F"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#3F3F3F"
theme.bg_focus  = "#CC9393"
theme.bg_urgent = "#3F3F3F"
-- }}}

-- {{{ Borders
theme.border_width  = "2"
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = home .. "/.config/awesome/zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = home .. "/.config/awesome/zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = home .. "/.config/awesome/zenburn/awesome-icon.png"
theme.menu_submenu_icon      = home .. "/.config/awesome/default/submenu.png"
theme.tasklist_floating_icon = home .. "/.config/awesome/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = home .. "/.config/awesome/zenburn/layouts/tile.png"
theme.layout_tileleft   = home .. "/.config/awesome/zenburn/layouts/tileleft.png"
theme.layout_tilebottom = home .. "/.config/awesome/zenburn/layouts/tilebottom.png"
theme.layout_tiletop    = home .. "/.config/awesome/zenburn/layouts/tiletop.png"
theme.layout_fairv      = home .. "/.config/awesome/zenburn/layouts/fairv.png"
theme.layout_fairh      = home .. "/.config/awesome/zenburn/layouts/fairh.png"
theme.layout_spiral     = home .. "/.config/awesome/zenburn/layouts/spiral.png"
theme.layout_dwindle    = home .. "/.config/awesome/zenburn/layouts/dwindle.png"
theme.layout_max        = home .. "/.config/awesome/zenburn/layouts/max.png"
theme.layout_fullscreen = home .. "/.config/awesome/zenburn/layouts/fullscreen.png"
theme.layout_magnifier  = home .. "/.config/awesome/zenburn/layouts/magnifier.png"
theme.layout_floating   = home .. "/.config/awesome/zenburn/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = home .. "/.config/awesome/zenburn/titlebar/close_focus.png"
theme.titlebar_close_button_normal = home .. "/.config/awesome/zenburn/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = home .. "/.config/awesome/zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = home .. "/.config/awesome/zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = home .. "/.config/awesome/zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = home .. "/.config/awesome/zenburn/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = home .. "/.config/awesome/zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = home .. "/.config/awesome/zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = home .. "/.config/awesome/zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = home .. "/.config/awesome/zenburn/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = home .. "/.config/awesome/zenburn/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = home .. "/.config/awesome/zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = home .. "/.config/awesome/zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = home .. "/.config/awesome/zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = home .. "/.config/awesome/zenburn/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = home .. "/.config/awesome/zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = home .. "/.config/awesome/zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = home .. "/.config/awesome/zenburn/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
