--
-- Please note not all available settings / options are set here.
-- For a full list, see the wiki
--

------------------
---- MONITORS ----
------------------

-- See https://wiki.hyprland.org/Configuring/Monitors/
-- hl.monitor({ output = "DP-1", mode = "3840x2160@119.910", position = "0x0", scale = 1.5, vrr = 1 })
-- hl.monitor({ output = "DP-2", mode = "3840x2160@59.997", position = "2560x0", scale = 1.5 })

hl.config({
	xwayland = {
		force_zero_scaling = true,
		use_nearest_neighbor = false,
		create_abstract_socket = true,
	},
})

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

-- Execute your favorite apps at launch
-- hl.exec_once("waybar & hyprpaper & firefox")

-- Source a file (multi-file configs)
-- require("myColors")

-- Some default env vars.

-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/
hl.config({
	input = {
		follow_mouse = 1,
		numlock_by_default = true,
	},

	cursor = {
		warp_on_change_workspace = true,
		inactive_timeout = 5,
		enable_hyprcursor = true,
	},

	general = {
		-- See https://wiki.hyprland.org/Configuring/Variables/ for more

		gaps_in = 5,
		gaps_out = 0,
		border_size = 0,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		layout = "dwindle",
		-- no_border_on_floating = true,
		resize_on_border = true,
	},

	decoration = {
		rounding = 0,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		dim_inactive = true,
		dim_strength = 0.08,

		blur = {
			enabled = true,
			size = 6,
			passes = 3,
			new_optimizations = true,
			ignore_opacity = true,
			xray = false,
		},

		shadow = {
			enabled = true,
			range = 30,
			render_power = 5,
			offset = { 0, 5 },
			color = "rgba(00000070)",
		},
	},

	animations = {
		enabled = true,
	},
})

-- Blur DMS overlays
hl.layer_rule({
	match = { namespace = "^dms:.*$" },
	blur = true,
	ignore_alpha = 0.2,
})

-- Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.config({
	dwindle = {
		-- pseudotile = true, -- master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
		preserve_split = true,
		force_split = 2,
	},

	master = {
		-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
		new_status = "master",
	},

	-- gestures = {
	-- See https://wiki.hyprland.org/Configuring/Variables/ for more
	-- workspace_swipe = false,
	-- },

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		enable_anr_dialog = false,
		vrr = 3,
	},

	render = {
		direct_scanout = 2,
		cm_enabled = false,
		cm_auto_hdr = 0,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

	debug = {
		disable_logs = true,
	},
})

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more
local mainMod = "SUPER"
local mainAlt = "SUPER + SHIFT"
local mainLock = "SUPER + SHIFT + CONTROL"
local mainMus = "CONTROL + SHIFT + ALT"

local function start_services(services, delay)
	delay = delay or 0.5
	local cmds = {}
	for _, service in ipairs(services) do
		table.insert(cmds, "systemctl --user start " .. service)
	end
	return table.concat(cmds, "; sleep " .. delay .. "; ")
end

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm-app ghostty +new-window"))
hl.bind(mainAlt .. " + Q", hl.dsp.window.close())
hl.bind(mainAlt .. " + X", hl.dsp.exec_cmd("loginctl terminate-user ''"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd("fuzzel --launch-prefix 'uwsm app --'"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))

hl.bind(mainAlt .. " + S", hl.dsp.exec_cmd("dms screenshot --no-file"))
hl.bind(mainAlt .. " + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))

hl.bind(mainAlt .. " + E", hl.dsp.exec_cmd("systemctl --user start easyeffects.service"))

hl.bind(mainAlt .. " + R", hl.dsp.exec_cmd("systemctl --user start heroic.service"))
hl.bind(mainAlt .. " + T", hl.dsp.exec_cmd("systemctl --user start steam.service"))
hl.bind(mainAlt .. " + U", hl.dsp.exec_cmd("systemctl --user start lutris.service"))
hl.bind(
	mainAlt .. " + F",
	hl.dsp.exec_cmd(
		"systemctl is-active --quiet --user firefox && firefox-developer-edition --browser || systemctl --user start firefox"
	)
)
hl.bind(mainAlt .. " + P", hl.dsp.exec_cmd("systemctl --user start firefox_p.service"))

hl.bind(
	mainAlt .. " + I",
	hl.dsp.exec_cmd(start_services({
		"slack.service",
		"signal.service",
		"discord.service",
	}))
)

hl.bind(
	mainAlt .. " + M",
	hl.dsp.exec_cmd(start_services({
		"sone.service",
		"easyeffects.service",
		"pwvucontrol.service",
	}))
)

-- hl.bind(mainMus .. " + B",      hl.dsp.exec_cmd("pkill -USR1 waybar"))
-- hl.bind(mainMus .. " + R",      hl.dsp.exec_cmd("pkill -USR2 waybar"))

-- hl.bind(mainLock .. " + S",     hl.dsp.exec_cmd("sh -c 'hyprlock --immediate &!; sleep 1; systemctl suspend'"))
hl.bind(mainLock .. " + L", hl.dsp.exec_cmd("dms ipc call lock lock"))

hl.bind(mainMus .. " + Space", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMus .. " + Left", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMus .. " + Right", hl.dsp.exec_cmd("playerctl next"))

-- Dedicated Audio & Volume Controls (supports holding & volume knob rotation, works when locked)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true })

-- Dedicated Media Control Keys (works when locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- resize submap (mode)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
	hl.bind("L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
	hl.bind("H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + escape", function()
	hl.dispatch(hl.dsp.submap("logout"))
	hl.notification.create({
		text = "e - exit\nr - reboot\ns - suspend\nS - poweroff\nl - lock\nx - termintate",
		timeout = 3500,
		icon = 0,
		color = "rgba(33ccffee)",
	})
end)

hl.define_submap("logout", function()
	hl.bind("E", hl.dsp.exec_cmd('loginctl terminate-session "$XDG_SESSION_ID"'), { release = true })
	hl.bind("X", hl.dsp.exec_cmd('loginctl terminate-user ""'), { release = true })
	hl.bind("S", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("sh -c 'dms ipc call lock lock &!; sleep 1; systemctl suspend'"))
	end, { release = true })
	hl.bind("R", hl.dsp.exec_cmd("systemctl reboot"), { release = true })
	hl.bind("L", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("dms ipc call lock lock"))
	end, { release = true })
	hl.bind("SHIFT + S", hl.dsp.exec_cmd("systemctl poweroff -i"), { release = true })
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Dialogs
-- hl.window_rule({ name = "open-file", match = { title = "^(Open File)(.*)$" }, float = true })
-- hl.window_rule({ name = "select-a-file", match = { title = "^(Select a File)(.*)$" }, float = true })
-- hl.window_rule({ name = "choose-wallpaper", match = { title = "^(Choose wallpaper)(.*)$" }, float = true })
-- hl.window_rule({ name = "open-folder", match = { title = "^(Open Folder)(.*)$" }, float = true })
-- hl.window_rule({ name = "save-as", match = { title = "^(Save As)(.*)$" }, float = true })
-- hl.window_rule({ name = "library", match = { title = "^(Library)(.*)$" }, float = true })
-- hl.window_rule({ name = "file-upload", match = { title = "^(File Upload)(.*)$" }, float = true })

-- Tearing

local function add_gaming_rule(name, match_criteria)
	hl.window_rule({
		name = name,
		match = match_criteria,
		no_anim = true,
		no_blur = true,
		no_dim = true,
		no_shadow = true,
		opaque = true,
		decorate = false,
		immediate = true,
		maximize = true,
		fullscreen = true,
		idle_inhibit = "always",
		tag = "+gaming",
	})
end

hl.window_rule({
	name = "set-content-game",
	match = { class = "^(steam_app_\\d+|gamescope)$" },
	content = "game",
})

add_gaming_rule("gaming-content", { content = 3 })
add_gaming_rule("gaming-gamescope", { class = "gamescope" })
add_gaming_rule("gaming-exe", { class = ".*\\.exe" })
add_gaming_rule("gaming-steam", { class = "steam_app.*" })

-- No shadow for tiled windows
hl.window_rule({
	name = "noshadow-tiled",
	match = { float = false },
	no_shadow = true,
})

hl.window_rule({
	name = "tag-floating-dialogs",
	match = {
		initial_title = "^(.*(Extension:.*Bitwarden|open|choose files|save (as|to)|confirm to replace|file operation).*)$",
	},
	tag = "+floating",
})

hl.window_rule({
	name = "apply-floating-tag",
	match = { tag = "floating" },
	suppress_event = "maximize",
	float = true,
})

-- hl.window_rule({
--     name             = "jetbrains-studio",
--     match            = { class = "jetbrains-studio", title = "^win(.*)" },
--     no_initial_focus = true,
-- })
-- hl.window_rule({
--     name             = "jetbrains-idea",
--     match            = { class = "jetbrains-idea", title = "^win.*" },
--     no_initial_focus = true,
-- })

-- Initialize uwsm-app and autostart
hl.on("hyprland.start", function()
	-- hl.exec_cmd("uwsm-app echo")
	hl.exec_cmd("bash /home/adam/.config/hypr/xdg.sh")
end)

require("dms.cursor")
require("dms.colors")
-- require("dms.layout")
require("dms.outputs")
