-- On-demand "morning startup": launch the usual apps and put each on its workspace/monitor.
--
-- Nothing here runs on its own; hyprland.lua binds `toggle` to a key. Pressing the key
-- while a run is in progress cancels it.
--
-- Routing uses window rules that stay disabled except during a run, so the apps only get
-- forced onto these workspaces when the sequence opens them. Opened another way, they land
-- wherever you are, as usual.
--
-- A run goes:
--   1. rhtop opens first. Its run0 pops a polkit dialog on the focused workspace, and the
--      rest waits for that to be answered (or cancelled), however long it takes, so nothing
--      opens or grabs focus while you type the password.
--   2. Everything else launches at once. The services are started one after another in list
--      order; that's quick (the units are Type=exec, so up once exec'd) and keeps their PIDs,
--      and so htop's tree, in this order.
--   3. Once every window has appeared and settled (or timed out), each workspace in `layouts`
--      is rebuilt: its windows are taken off and put back in order, each splitting the one
--      before, so dwindle ends up the same however the apps raced each other.
--
-- The terminals are new windows of the already-running ghostty service (so they live under
-- it, not under Hyprland). They all share its class, so each gets a fixed title to be told
-- apart by. `fish -C` runs the command in an interactive shell, so quitting it leaves a
-- prompt like running it by hand does.

local M = {}

local MON1, MON2 = "DP-1", "DP-2"

-- class:    exact window class to wait for (and route)
-- title:    optional exact title the window must also have before the task counts as up
-- unit:     user service (without .service) that starts the app
-- term:     a terminal running this fish command; fills in class and title
-- settle:   ms with no new matching windows before the task is done (firefox session
--           restore opens its windows one by one; steam shows an updater window first)
-- timeout:  seconds to wait for the window before giving up

local GHOSTTY = "com.mitchellh.ghostty"

-- Starting the service is a no-op when it's already up (and waits for it when it isn't).
local function term_cmd(name)
	return "systemctl --user start app-"
		.. GHOSTTY
		.. ".service && ghostty +new-window --title="
		.. name
		.. " -e fish -C '"
		.. name
		.. "'"
end

-- Exact size, in the logical pixels `hyprctl clients` reports. In dwindle this moves the
-- split(s) next to the window.
local function resize(id, w, h)
	local win = M.find(id)
	if win then
		hl.dispatch(hl.dsp.window.resize({ x = w, y = h, window = win }))
	end
end

-- Launched in this order (the first is the password gate, see above).
local tasks = {
	{ id = "rhtop", ws = 10, mon = MON2, term = "rhtop", settle = 500 },
	{ id = "firefox", ws = 1, mon = MON1, class = "firefox-developer-edition", unit = "firefox", settle = 3000 },
	{
		id = "steam",
		ws = 5,
		mon = MON1,
		class = "steam",
		title = "Steam",
		unit = "steam",
		settle = 2000,
		timeout = 300,
	},
	{ id = "heroic", ws = 5, mon = MON1, class = "heroic", unit = "heroic" },
	{ id = "slack", ws = 9, mon = MON2, class = "slack", unit = "slack", settle = 1000 },
	{ id = "signal", ws = 9, mon = MON2, class = "signal", unit = "signal", settle = 1000 },
	{ id = "discord", ws = 9, mon = MON2, class = "discord", unit = "discord" },
	{ id = "easyeffects", ws = 8, mon = MON2, class = "com.github.wwmm.easyeffects", unit = "easyeffects" },
	{ id = "nvtop", ws = 10, mon = MON2, term = "nvtop", settle = 500 },
	{ id = "jtail", ws = 10, mon = MON2, term = "jtail", settle = 500 },
}

-- Tiled workspaces rebuilt at the end (on the first task's workspace), in this order; then
-- `resize` runs.
local layouts = {
	{ "steam", "heroic" },
	-- slack on the left, signal over discord on the right
	{ "slack", "signal", "discord" },
	-- htop on the left, nvtop over jtail on the right
	{
		"rhtop",
		"nvtop",
		"jtail",
		resize = function()
			resize("rhtop", 1505, 1400)
			resize("nvtop", 1047, 997)
		end,
	},
}

-- Workspaces to show at the end, in order (the last one ends up focused).
local finish_on = { 10, 1 }

local GATE = tasks[1]
-- The polkit agent's dialog.
local PROMPT = { class = "hyprpolkitagent", title = "Authentication Required" }
-- How long after the gate's window is up to wait for a dialog before deciding none is coming.
local PROMPT_WAIT_MS = 5000

-- Where a layout's windows wait while their workspace is rebuilt.
local STASH = "special:startup"

local DEFAULT_TIMEOUT = 90
local TICK_MS = 250

local by_id = {}
local function exact(str)
	return "^" .. str:gsub("[%.%-]", "\\%0") .. "$"
end

for _, t in ipairs(tasks) do
	by_id[t.id] = t
	local match
	if t.term then
		t.class, t.title, t.cmd = GHOSTTY, t.term, term_cmd(t.term)
		match = { class = exact(t.class), initial_title = exact(t.title) }
	else
		t.cmd = "systemctl --user start " .. t.unit .. ".service"
		match = { class = exact(t.class) }
	end
	t.rule = hl.window_rule({
		name = "startup-" .. t.id,
		enabled = false,
		match = match,
		monitor = t.mon,
		workspace = t.ws .. " silent",
	})
end

---@type { timer: HL.Timer, note: HL.Notification, state: table<string, table>, gated: boolean, prompted: boolean }|nil
local run = nil

-- os.time() only has whole seconds, so time is counted in timer ticks.
local ticks = 0
local function now_ms()
	return ticks * TICK_MS
end

-- A `title` also requires a tiled window, to skip steam's floating updater/login windows.
local function matches(t, w)
	return w.class == t.class and (not t.title or (w.title == t.title and not w.floating))
end

function M.find(id)
	local t = by_id[id]
	for _, w in ipairs(hl.get_windows()) do
		if matches(t, w) then
			return w
		end
	end
end

local function count(t)
	local n = 0
	for _, w in ipairs(hl.get_windows()) do
		if matches(t, w) then
			n = n + 1
		end
	end
	return n
end

local function prompt_open()
	for _, w in ipairs(hl.get_windows()) do
		if w.class == PROMPT.class and w.title == PROMPT.title then
			return true
		end
	end
	return false
end

local marks = {
	waiting = "·",
	launching = "…",
	settling = "…",
	done = "✓",
	failed = "✗",
}

local function render(state)
	local lines = { "startup" }
	for _, t in ipairs(tasks) do
		local s = state[t.id]
		lines[#lines + 1] = string.format("%s %s%s", marks[s.status], t.id, s.note and (" (" .. s.note .. ")") or "")
	end
	return table.concat(lines, "\n")
end

local pending = { waiting = true, launching = true, settling = true }

local function set_rules(on)
	for _, t in ipairs(tasks) do
		t.rule:set_enabled(on)
	end
end

local function stop(text, color)
	if not run then
		return
	end
	run.timer:set_enabled(false)
	set_rules(false)
	if run.note:is_alive() then
		run.note:dismiss()
	end
	hl.notification.create({ text = text, timeout = 4000, icon = 0, color = color })
	run = nil
end

-- Marks the task done if its window is already open, otherwise returns its command.
local function launch(t, s)
	if count(t) > 0 then
		s.status, s.note, s.since = "done", "already open", now_ms()
		return nil
	end
	s.status, s.since = "launching", now_ms()
	return t.cmd
end

-- Everything after the gate. The service starts go in one shell, one after another, so
-- their PIDs follow the list; the terminals don't need ordering.
local function launch_rest(state)
	local units = {}
	for _, t in ipairs(tasks) do
		if t ~= GATE then
			local cmd = launch(t, state[t.id])
			if cmd and t.unit then
				units[#units + 1] = cmd
			elseif cmd then
				hl.exec_cmd(cmd)
			end
		end
	end
	if #units > 0 then
		hl.exec_cmd(table.concat(units, "; "))
	end
end

-- Dwindle splits the focused window, and follow_mouse can refocus whatever is under the
-- pointer, so the window gets focus and the pointer is parked on it.
local function point_at(win)
	hl.dispatch(hl.dsp.focus({ window = win }))
	hl.dispatch(hl.dsp.cursor.move({ x = win.at.x + win.size.x / 2, y = win.at.y + win.size.y / 2 }))
end

local function rebuild(layout)
	local first = by_id[layout[1]]
	local present = {}
	for _, id in ipairs(layout) do
		if M.find(id) then
			present[#present + 1] = id
		end
	end
	if #present > 1 then
		for _, id in ipairs(present) do
			hl.dispatch(hl.dsp.window.move({ workspace = STASH, follow = false, window = M.find(id) }))
		end
		-- focusing the monitor first means a workspace that doesn't exist yet is made there
		hl.dispatch(hl.dsp.focus({ monitor = first.mon }))
		hl.dispatch(hl.dsp.focus({ workspace = first.ws }))
		for i, id in ipairs(present) do
			if i > 1 then
				point_at(M.find(present[i - 1]))
			end
			hl.dispatch(hl.dsp.window.move({ workspace = first.ws, follow = false, window = M.find(id) }))
		end
	end
	if layout.resize then
		layout.resize()
	end
end

-- Apps that open in the background mark themselves urgent; visiting each window clears
-- that. Capped, and stops if focusing doesn't clear it, so this can't loop forever.
local function clear_urgent()
	local last
	for _ = 1, 50 do
		local w = hl.get_urgent_window()
		if not w or w.address == last then
			return
		end
		last = w.address
		hl.dispatch(hl.dsp.focus({ window = w }))
	end
end

local function finish(state)
	for _, layout in ipairs(layouts) do
		rebuild(layout)
	end
	clear_urgent()
	for _, ws in ipairs(finish_on) do
		hl.dispatch(hl.dsp.focus({ workspace = ws }))
	end
	local failed = {}
	for _, t in ipairs(tasks) do
		if state[t.id].status == "failed" then
			failed[#failed + 1] = t.id
		end
	end
	if #failed == 0 then
		stop("startup: done", "rgba(66ff99ee)")
	else
		stop("startup: done, but not: " .. table.concat(failed, ", "), "rgba(ff6666ee)")
	end
end

-- Moves a launched task along as its window(s) appear and settle.
local function advance(t, s, t_now)
	if s.status == "launching" then
		local n = count(t)
		if n > 0 then
			s.status, s.seen, s.since = "settling", n, t_now
		elseif t_now - s.since > (t.timeout or DEFAULT_TIMEOUT) * 1000 then
			s.status, s.note, s.since = "failed", "timed out", t_now
		end
	elseif s.status == "settling" then
		local n = count(t)
		if n == 0 then
			-- the window closed again before settling; keep waiting (timeout restarts)
			s.status, s.since = "launching", t_now
		elseif n > s.seen then
			s.seen, s.since = n, t_now
		elseif t_now - s.since >= (t.settle or 0) then
			s.status, s.since = "done", t_now
		end
	end
end

-- Lets the rest go once the gate's prompt has come and gone, or never showed up.
local function check_gate(r, t_now)
	local g = r.state[GATE.id]
	if prompt_open() then
		r.prompted = true
		g.note = "waiting for password"
		return false
	end
	if pending[g.status] and not r.prompted then
		return false
	end
	if not r.prompted and g.status == "done" and g.note ~= "already open" and t_now - g.since < PROMPT_WAIT_MS then
		return false
	end
	if g.note == "waiting for password" then
		g.note = nil
	end
	return true
end

local function tick()
	if not run then
		return
	end
	local state = run.state
	ticks = ticks + 1
	local t_now = now_ms()

	local before = render(state)
	for _, t in ipairs(tasks) do
		advance(t, state[t.id], t_now)
	end
	if not run.gated and check_gate(run, t_now) then
		run.gated = true
		launch_rest(state)
	end

	local all_done = run.gated
	for _, t in ipairs(tasks) do
		if pending[state[t.id].status] then
			all_done = false
		end
	end

	if all_done then
		finish(state)
	elseif run.note:is_alive() then
		local text = render(state)
		if text ~= before then
			run.note:set_text(text)
		end
	end
end

function M.toggle()
	if run then
		stop("startup: cancelled", "rgba(ff6666ee)")
		return
	end

	ticks = 0
	local state = {}
	for _, t in ipairs(tasks) do
		state[t.id] = { status = "waiting" }
	end
	set_rules(true)
	local cmd = launch(GATE, state[GATE.id])
	if cmd then
		hl.exec_cmd(cmd)
	end
	run = {
		state = state,
		gated = false,
		prompted = false,
		note = hl.notification.create({ text = render(state), timeout = 600000, icon = 0, color = "rgba(33ccffee)" }),
		timer = hl.timer(tick, { timeout = TICK_MS, type = "repeat" }),
	}
end

return M
