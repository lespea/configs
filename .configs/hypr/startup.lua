-- On-demand "morning startup": launch the usual apps and put each on its workspace/monitor.
--
-- Nothing here runs on its own; hyprland.lua binds `toggle` to a key. Pressing the key
-- while a run is in progress cancels it.
--
-- Routing uses window rules that stay disabled except during a run, so the apps only get
-- forced onto these workspaces when the sequence opens them. Opened another way, they land
-- wherever you are, as usual.
--
-- Tasks without a dependency launch immediately and in parallel. Otherwise:
--   after:        wait until that task's window has appeared and settled; if it never does,
--                 this task is skipped. Used so dwindle splits in the right order (heroic
--                 beside steam; signal beside slack, then discord under signal).
--   after_launch: wait until that task has been launched (or given up on). Only orders the
--                 launches, so the services' PIDs, and so htop's tree, follow this list.
--   after_finish: wait until that task is finished, however it went. The terminals use it
--                 so their splits don't interleave with discord's on the same monitor.
--
-- The terminals are new windows of the already-running ghostty service (so they live under
-- it, not under Hyprland). They all share its class, so each gets a fixed title to be told
-- apart by. `fish -C` runs the command in an interactive shell, so quitting it leaves a
-- prompt like running it by hand does.
--
-- rhtop's run0 pops a polkit dialog on whatever workspace is focused, so its terminal holds
-- off until the run has ended (and focused workspace 1) before running it.

local M = {}

local MON1, MON2 = "DP-1", "DP-2"

-- class:    exact window class to wait for (and route)
-- title:    optional exact title the window must also have before the task counts as up
-- term:     a terminal running this fish command; fills in class, title and cmd
-- settle:   ms with no new matching windows before the task is done (firefox session
--           restore opens its windows one by one; steam shows an updater window first)
-- timeout:  seconds to wait for the window before giving up (dependents are skipped)
-- split:    task whose window the new one should split. Dwindle splits the focused window,
--           and follow_mouse can refocus whatever is under the pointer, so that window gets
--           focus and the pointer is parked on it (the manual "move the mouse there" step).
-- hold:     (term only) don't run the command until the run has ended
-- on_done:  called once the task's window has settled (not when it was already open)

-- Exists while a run is in progress; held terminals wait for it to go away.
local HOLD = "$XDG_RUNTIME_DIR/hypr-startup.hold"

local GHOSTTY = "com.mitchellh.ghostty"

-- Starting the service is a no-op when it's already up (and waits for it when it isn't).
local function term_cmd(name, hold)
	local cmd = hold and ("while test -e " .. HOLD .. "; sleep 0.25; end; " .. name) or name
	return "systemctl --user start app-" .. GHOSTTY .. ".service && ghostty +new-window --title="
		.. name .. " -e fish -C '" .. cmd .. "'"
end

-- Exact size, in the logical pixels `hyprctl clients` reports. In dwindle this moves the
-- split(s) next to the window.
local function resize(id, w, h)
	local win = M.find(id)
	if win then
		hl.dispatch(hl.dsp.window.resize({ x = w, y = h, window = win }))
	end
end

local tasks = {
	{
		id = "firefox",
		ws = 1,
		mon = MON1,
		class = "firefox-developer-edition",
		cmd = "systemctl --user start firefox.service",
		settle = 3000,
	},
	{
		id = "steam",
		ws = 5,
		mon = MON1,
		class = "steam",
		title = "Steam",
		cmd = "systemctl --user start steam.service",
		settle = 2000,
		timeout = 300,
	},
	{
		id = "heroic",
		after = "steam",
		ws = 5,
		mon = MON1,
		class = "heroic",
		cmd = "systemctl --user start heroic.service",
	},
	-- Workspace 9: slack on the left, signal over discord on the right.
	{
		id = "slack",
		after_launch = "heroic",
		ws = 9,
		mon = MON2,
		class = "slack",
		cmd = "systemctl --user start slack.service",
		settle = 1000,
	},
	{
		id = "signal",
		after = "slack",
		ws = 9,
		mon = MON2,
		class = "signal",
		cmd = "systemctl --user start signal.service",
		settle = 1000,
	},
	{
		id = "discord",
		after = "signal",
		ws = 9,
		mon = MON2,
		class = "discord",
		split = "signal",
		cmd = "systemctl --user start discord.service",
	},
	{
		id = "easyeffects",
		after_launch = "discord",
		ws = 8,
		mon = MON2,
		class = "com.github.wwmm.easyeffects",
		cmd = "systemctl --user start easyeffects.service",
	},
	-- Workspace 10: htop on the left, nvtop over jtail on the right.
	{
		id = "rhtop",
		after_finish = "discord",
		ws = 10,
		mon = MON2,
		term = "rhtop",
		hold = true,
		settle = 500,
	},
	{
		id = "nvtop",
		after = "rhtop",
		split = "rhtop",
		ws = 10,
		mon = MON2,
		term = "nvtop",
		settle = 500,
	},
	{
		id = "jtail",
		after = "nvtop",
		split = "nvtop",
		ws = 10,
		mon = MON2,
		term = "jtail",
		settle = 500,
		on_done = function()
			resize("rhtop", 1505, 1400)
			resize("nvtop", 1047, 997)
		end,
	},
}

-- Workspaces to show at the end, in order (the last one ends up focused).
local finish_on = { 10, 1 }

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
		t.class, t.title, t.cmd = GHOSTTY, t.term, term_cmd(t.term, t.hold)
		match = { class = exact(t.class), initial_title = exact(t.title) }
	else
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

---@type { timer: HL.Timer, note: HL.Notification, state: table<string, table> }|nil
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

local marks = {
	waiting = "·",
	launching = "…",
	settling = "…",
	done = "✓",
	skipped = "↷",
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

local finished = { done = true, skipped = true, failed = true }

-- "go", "skip", or nil to keep waiting.
local function ready(t, state)
	local dep = t.after and state[t.after]
	if dep and (dep.status == "failed" or dep.status == "skipped") then
		return "skip"
	elseif dep and dep.status ~= "done" then
		return nil
	elseif t.after_launch and state[t.after_launch].status == "waiting" then
		return nil
	elseif t.after_finish and not finished[state[t.after_finish].status] then
		return nil
	end
	return "go"
end

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
	hl.exec_cmd("rm -f " .. HOLD)
	if run.note:is_alive() then
		run.note:dismiss()
	end
	hl.notification.create({ text = text, timeout = 4000, icon = 0, color = color })
	run = nil
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
	clear_urgent()
	for _, ws in ipairs(finish_on) do
		hl.dispatch(hl.dsp.focus({ workspace = ws }))
	end
	local failed = {}
	for _, t in ipairs(tasks) do
		local status = state[t.id].status
		if status == "failed" or status == "skipped" then
			failed[#failed + 1] = t.id
		end
	end
	if #failed == 0 then
		stop("startup: done", "rgba(66ff99ee)")
	else
		stop("startup: done, but not: " .. table.concat(failed, ", "), "rgba(ff6666ee)")
	end
end

local function tick()
	if not run then
		return
	end
	local state = run.state
	ticks = ticks + 1
	local t_now = now_ms()
	local changed, all_done = false, true

	for _, t in ipairs(tasks) do
		local s = state[t.id]
		local prev = s.status

		if s.status == "waiting" then
			local r = ready(t, state)
			if r == "skip" then
				s.status, s.note = "skipped", t.after .. " missing"
			elseif r == "go" then
				if count(t) > 0 then
					s.status, s.note = "done", "already open"
				else
					local target = t.split and M.find(t.split)
					if target then
						hl.dispatch(hl.dsp.focus({ window = target }))
						hl.dispatch(hl.dsp.cursor.move({
							x = target.at.x + target.size.x / 2,
							y = target.at.y + target.size.y / 2,
						}))
					end
					hl.exec_cmd(t.cmd)
					s.status, s.since = "launching", t_now
				end
			end
		elseif s.status == "launching" then
			local n = count(t)
			if n > 0 then
				s.status, s.seen, s.since = "settling", n, t_now
			elseif t_now - s.since > (t.timeout or DEFAULT_TIMEOUT) * 1000 then
				s.status, s.note = "failed", "timed out"
			end
		elseif s.status == "settling" then
			local n = count(t)
			if n == 0 then
				-- the window closed again before settling; keep waiting (timeout restarts)
				s.status, s.since = "launching", t_now
			elseif n > s.seen then
				s.seen, s.since = n, t_now
			elseif t_now - s.since >= (t.settle or 0) then
				s.status = "done"
				if t.on_done then
					t.on_done()
				end
			end
		end

		changed = changed or s.status ~= prev
		if s.status == "waiting" or s.status == "launching" or s.status == "settling" then
			all_done = false
		end
	end

	if all_done then
		finish(state)
	elseif changed and run.note:is_alive() then
		run.note:set_text(render(state))
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
	hl.exec_cmd("touch " .. HOLD)
	run = {
		state = state,
		note = hl.notification.create({ text = render(state), timeout = 600000, icon = 0, color = "rgba(33ccffee)" }),
		timer = hl.timer(tick, { timeout = TICK_MS, type = "repeat" }),
	}
end

return M
