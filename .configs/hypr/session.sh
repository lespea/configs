#!/bin/sh
# Session-ending actions for the SUPER+Escape submap in hyprland.lua.
#
# Must run in its own transient user unit (hyprland.lua wraps it in `systemd-run --user`):
# the compositor unit is KillMode=control-group, so anything Hyprland spawned directly
# would be killed by `uwsm stop` before it could run the next step.
#
# `uwsm stop` stops graphical-session.target: app units (PartOf/After the target) are
# stopped first and get their KillMode=mixed SIGTERM, then Hyprland goes down. The tty
# login is `exec uwsm start`, so that session ends on its own afterwards.
set -u

case "${1-}" in
	exit)
		# Leave the desktop; other logins (ssh, ttys) and user services stay.
		uwsm stop
		;;
	terminate)
		# Leave the desktop, then end every remaining session and the user manager.
		uwsm stop
		loginctl terminate-user "$(id -un)"
		;;
	reboot)
		uwsm stop
		systemctl reboot
		;;
	poweroff)
		uwsm stop
		systemctl poweroff -i
		;;
	*)
		echo "usage: $0 exit|terminate|reboot|poweroff" >&2
		exit 2
		;;
esac
