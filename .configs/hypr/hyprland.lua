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
		warp_on_change_workspace = false,
		inactive_timeout = 30,
		enable_hyprcursor = true,
	},

	general = {
		-- See https://wiki.hyprland.org/Configuring/Variables/ for more

		-- gaps, borders, colours and rounding are managed by DMS: dms.layout and dms.colors
		-- are imported at the end of this file and override anything set here.
		-- gaps_in = 5,
		-- gaps_out = 0,
		-- border_size = 0,
		-- col = {
		-- 	active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
		-- 	inactive_border = "rgba(595959aa)",
		-- },
		-- resize_on_border = true,

		layout = "dwindle",
		-- no_border_on_floating = true,
	},

	decoration = {
		-- rounding = 0, -- managed by dms.layout

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
		-- vrr = 3, -- no effect: per-monitor vrr = 1 in dms.outputs overrides it (VRR always on)
		render_unfocused_fps = 60,
	},

	render = {
		direct_scanout = 2,
		cm_enabled = false,
		cm_auto_hdr = 0,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
		-- Clients must be allowed (below) or get a prompt before they can capture the screen,
		-- grab the keyboard, or load plugins. Changes here need a restart, not a reload.
		enforce_permissions = true,
	},

	debug = {
		disable_logs = true,
	},
})

-- Permissions: matched against the client's binary path (RE2 regex). Screen sharing in
-- Firefox/Discord/Slack goes through the portal, so the portal backend is the only client
-- that needs screencopy for it. OBS uses the portal too. Anything not listed gets an
-- allow/deny dialog, remembered for the session.
local allow_screencopy = {
	"^/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland$",
	"^/usr/bin/dms$", -- dms screenshot
	"^/usr/bin/quickshell$", -- DMS shell itself (lock screen, previews)
	"^/usr/bin/grim$",
	"^/usr/bin/hyprpicker$",
}
for _, binary in ipairs(allow_screencopy) do
	hl.permission({ binary = binary, type = "screencopy", mode = "allow" })
end

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more
local mainMod = "SUPER"
local mainAlt = "SUPER + SHIFT"
local mainLock = "SUPER + SHIFT + CONTROL"
local mainMus = "CONTROL + SHIFT + ALT"

-- Directory this config file lives in, so helper scripts next to it can be found.
local config_dir = debug.getinfo(1, "S").source:match("^@(.*)/") or "."

local function start_services(services, delay)
	delay = delay or 0.5
	local cmds = {}
	for _, service in ipairs(services) do
		table.insert(cmds, "systemctl --user start " .. service)
	end
	return table.concat(cmds, "; sleep " .. delay .. "; ")
end

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty +new-window"))
hl.bind(mainAlt .. " + Q", hl.dsp.window.close())
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

-- Launch the usual apps onto their workspaces (see startup.lua); press again to cancel
hl.bind(mainLock .. " + S", require("startup").toggle)

-- Key "menus": a submap plus a notification listing its keys. Picking an entry flashes
-- just that line in green for half a second, then clears the popup.
local menu_color = "rgba(33ccffee)"
local menu_pick_color = "rgba(66ff99ee)"
local function dismiss(note)
	if note and note:is_alive() then
		note:dismiss()
	end
end
local function define_menu(name, trigger, entries)
	-- `flash` holds the pending timer so it isn't collected before it fires
	local menu = { note = nil, flash = nil }

	hl.bind(trigger, function()
		dismiss(menu.note)
		hl.dispatch(hl.dsp.submap(name))
		local lines = {}
		for _, e in ipairs(entries) do
			lines[#lines + 1] = e.label
		end
		menu.note = hl.notification.create({
			text = table.concat(lines, "\n"),
			timeout = 3500,
			icon = 0,
			color = menu_color,
		})
	end)

	hl.define_submap(name, function()
		for _, e in ipairs(entries) do
			hl.bind(e.key, function()
				hl.dispatch(hl.dsp.submap("reset"))
				local picked = menu.note
				menu.note = nil
				if picked and picked:is_alive() then
					picked:set_text(e.label)
					picked:set_color(menu_pick_color)
					menu.flash = hl.timer(function()
						dismiss(picked)
					end, { timeout = 500, type = "oneshot" })
				end
				hl.dispatch(e.action)
			end, { release = true })
		end
		for _, key in ipairs({ "escape", "Return" }) do
			hl.bind(key, function()
				hl.dispatch(hl.dsp.submap("reset"))
				dismiss(menu.note)
				menu.note = nil
			end)
		end
	end)
end

define_menu("media", mainAlt .. " + M", {
	{
		key = "M",
		label = "m - all (tidal + easyeffects + pavu)",
		action = hl.dsp.exec_cmd(start_services({
			"tidal.service",
			"easyeffects.service",
			"pavucontrol.service",
		}, 0.75)),
	},
	{ key = "T", label = "t - tidal", action = hl.dsp.exec_cmd("systemctl --user start tidal.service") },
	{ key = "E", label = "e - easyeffects", action = hl.dsp.exec_cmd("systemctl --user start easyeffects.service") },
	{ key = "P", label = "p - pavucontrol", action = hl.dsp.exec_cmd("systemctl --user start pavucontrol.service") },
	{
		key = "Q",
		label = "q - stop all",
		action = hl.dsp.exec_cmd("systemctl --user stop tidal.service easyeffects.service pavucontrol.service"),
	},
})

hl.bind(mainAlt .. " + C", function()
	hl.exec_cmd("systemctl --user start rift.service")
	hl.exec_cmd(
		"systemctl is-active --quiet --user mumble && busctl --user --expect-reply=false call info.mumble.mumble / info.mumble.Mumble focus || systemctl --user start mumble.service"
	)
end)

-- hl.bind(mainMus .. " + B",      hl.dsp.exec_cmd("pkill -USR1 waybar"))
-- hl.bind(mainMus .. " + R",      hl.dsp.exec_cmd("pkill -USR2 waybar"))

-- hl.bind(mainLock .. " + S",     hl.dsp.exec_cmd("sh -c 'hyprlock --immediate &!; sleep 1; systemctl suspend'"))
hl.bind(mainLock .. " + L", hl.dsp.exec_cmd("dms ipc call lock lock"))

hl.bind(mainMus .. " + Space", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMus .. " + Left", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMus .. " + Right", hl.dsp.exec_cmd("playerctl next"))

-- Toggle confine_pointer for the active window (useful for games)
hl.bind(mainMus .. " + M", function()
	local w = hl.get_active_window()
	if not w then
		return
	end
	local has_tag = false
	for _, t in
		ipairs(w.tags --[[@as table]])
	do
		if t == "confine_ptr" then
			has_tag = true
			break
		end
	end
	if has_tag then
		hl.dispatch(hl.dsp.window.tag({ tag = "-confine_ptr" }))
		hl.notification.create({ text = "Pointer freed", timeout = 1500, icon = 0 })
	else
		hl.dispatch(hl.dsp.window.tag({ tag = "+confine_ptr" }))
		hl.notification.create({ text = "Pointer confined", timeout = 1500, icon = 0 })
	end
end)

-- Dedicated Audio & Volume Controls (supports holding & volume knob rotation, works when locked)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true })

-- Mumble Comms (D-Bus RPC from ~/opt/mumble rpc-whisper branch)
local function mumble(method, sig, ...)
	local cmd = "busctl --user --expect-reply=false call info.mumble.mumble / info.mumble.Mumble " .. method
	if sig then
		cmd = cmd .. " " .. sig
		for _, arg in ipairs({ ... }) do
			cmd = cmd .. " " .. string.format("%q", tostring(arg))
		end
	end
	hl.exec_cmd(cmd)
end

local mumble_talk = { active = false, note = nil }

local function mumble_start(label, method, sig, ...)
	mumble(method, sig, ...)
	mumble_talk.active = true
	if mumble_talk.note then
		mumble_talk.note:dismiss()
	end
	-- Stays up while transmitting; the long timeout is only a fallback
	mumble_talk.note =
		hl.notification.create({ text = label, timeout = 120000, icon = "info", color = "rgba(33ccffee)" })
end

local function mumble_stop()
	if not mumble_talk.active then
		return
	end
	mumble_talk.active = false
	mumble("stopShout") -- clears every active RPC whisper/shout
	if mumble_talk.note then
		mumble_talk.note:dismiss()
		mumble_talk.note = nil
	end
end

-- 1. Whisper to Current Channel (SUPER + Mouse4 / Back button)
hl.bind(mainMod .. " + mouse:275", function()
	mumble_start("Mumble: whisper (channel)", "startWhisper", "s", "current")
end)

-- 2. Shout to Parent + Subchannels, e.g. whole fleet minus command (SUPER + Mouse5 / Forward button)
hl.bind(mainMod .. " + mouse:276", function()
	mumble_start("Mumble: shout (parent + subchannels)", "startShout", "s", "parent")
end)

-- 3. Shout to Current + Subchannels + Linked channels, reaches command (SUPER + SHIFT + Mouse4)
--    startShout args: channel, links, forceCenter, group
hl.bind(mainAlt .. " + mouse:275", function()
	mumble_start("Mumble: shout (linked, incl. command)", "startShout", "sbbs", "current", true, false, "")
end)

-- Stop on button release no matter which modifiers are still held (letting go of SUPER first
-- would otherwise skip the release bind and leave us transmitting). non_consuming keeps plain
-- back/forward clicks working; mumble_stop is a no-op unless one of the binds above is active.
for _, button in ipairs({ "mouse:275", "mouse:276" }) do
	hl.bind(button, mumble_stop, { release = true, ignore_mods = true, non_consuming = true })
end

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

-- Session-ending actions go through session.sh, launched as a transient user unit so
-- the script outlives the compositor (see the comment in session.sh).
local session_script = config_dir .. "/session.sh"
local function session_end(action)
	return hl.dsp.exec_cmd("systemd-run --user --quiet --collect -- " .. session_script .. " " .. action)
end

define_menu("logout", mainMod .. " + escape", {
	{ key = "E", label = "e - exit session", action = session_end("exit") },
	{ key = "X", label = "x - terminate everything", action = session_end("terminate") },
	{ key = "R", label = "r - reboot", action = session_end("reboot") },
	{
		key = "S",
		label = "s - suspend",
		action = hl.dsp.exec_cmd("sh -c 'dms ipc call lock lock & sleep 1; systemctl suspend'"),
	},
	{ key = "SHIFT + S", label = "S - poweroff", action = session_end("poweroff") },
	{ key = "L", label = "l - lock", action = hl.dsp.exec_cmd("dms ipc call lock lock") },
})

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
		-- No `immediate` (tearing): both monitors run VRR, which covers the latency case
		-- without tearing, and general.allow_tearing is off anyway.
		fullscreen = true,
		idle_inhibit = "always",
		tag = "+gaming",
		content = "game", -- gates direct scanout (render.direct_scanout = 2); class alone misses winewayland games
		render_unfocused = true,
	})
end

hl.window_rule({
	name = "set-content-game",
	match = { class = "^(steam_app_\\d+|gamescope)$" },
	content = "game",
})

add_gaming_rule("gaming-content", { content = "game" })
add_gaming_rule("gaming-gamescope", { class = "gamescope" })
add_gaming_rule("gaming-exe", { class = ".*\\.exe" })
add_gaming_rule("gaming-steam", { class = "steam_app.*" })

-- Wine launchers (Ubisoft Connect, Battle.net, EA, Epic, GOG, ...) match the .exe rule
-- above but are ordinary windows. Rules apply in order, so this undoes just the game
-- treatment for them. Add classes as you meet them (`hyprctl clients` shows the class).
hl.window_rule({
	name = "launchers-not-games",
	match = {
		class = "(?i)^(upc|ubisoftconnect|ubisoft game launcher|battle\\.net|agent|eadesktop|ealauncher|epicgameslauncher|galaxyclient|rockstar|launcher|origin|eve-online)\\.exe$",
	},
	fullscreen = false,
	idle_inhibit = "none",
	render_unfocused = false,
	tag = "-gaming",
	content = "none",
})

-- Steam draws its own toasts as XWayland windows pinned to the screen corner, ignoring
-- reserved space, so they land under the DMS bar. Lift them clear of the 40px strip.
hl.window_rule({
	name = "steam-toasts",
	match = { class = "^steam$", title = "^notificationtoasts" },
	float = true,
	no_initial_focus = true,
	move = "monitor_w-window_w-8 monitor_h-window_h-48",
})

-- No shadow for tiled windows
hl.window_rule({
	name = "noshadow-tiled",
	match = { float = false },
	no_shadow = true,
})

-- Confine pointer to windows tagged via CTRL+SHIFT+ALT+M
hl.window_rule({
	name = "confine-tagged",
	match = { tag = "confine_ptr" },
	confine_pointer = 1,
})

hl.window_rule({
	name = "tag-floating-dialogs",
	match = {
		initial_title = "(?i)^(.*(Extension:.*Bitwarden|open|choose files|save (as|to)|confirm to replace|file operation).*)$",
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
	hl.exec_cmd("uwsm-app echo")
end)

local function import_nowatch(modname)
	local path, err = package.searchpath(modname, package.path)
	if not path then
		error(string.format("module '%s' not found: %s", modname, err))
	end
	local fn, load_err = loadfile(path)
	if not fn then
		error(string.format("error loading module '%s' from '%s': %s", modname, path, load_err))
	end
	local res = fn()
	package.loaded[modname] = res or true
	return res
end

import_nowatch("dms.cursor")
import_nowatch("dms.colors")
import_nowatch("dms.outputs")
import_nowatch("dms.layout")
import_nowatch("dms.windowrules")
