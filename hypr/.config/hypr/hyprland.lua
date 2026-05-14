-- hyprland.lua — Hyprland 0.55+ Lua config
-- API reference: /usr/share/hypr/stubs/hl.meta.lua

-- ============================================================
-- MONITORS
-- ============================================================
hl.monitor({ output = "HDMI-A-1", mode = "1920x1200@60", position = "1920x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "1920x1200@120", position = "0x0", scale = 1 })

-- ============================================================
-- PROGRAMS
-- ============================================================
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "pkill wofi || wofi --show drun"
local browser     = "firefox"
local notes       = "obsidian"

-- ============================================================
-- AUTOSTART
-- ============================================================
hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("~/.config/hypr/scripts/random-wallpaper.sh")
	hl.exec_cmd("mako")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("waybar")
	hl.exec_cmd("[workspace 1 silent] " .. browser)
	hl.exec_cmd("[workspace 2 silent] " .. terminal)
	hl.exec_cmd("[workspace 9 silent] spotify")
	hl.exec_cmd("hypridle")
end)

-- ============================================================
-- ENVIRONMENT VARIABLES
-- ============================================================
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ============================================================
-- CONFIGURATION
-- ============================================================
hl.config({
	general = {
		gaps_in  = 1,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border   = "rgba(313244aa)",
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border   = false,
		allow_tearing      = false,
		hover_icon_on_border = true,
		layout = "dwindle",
	},
	decoration = {
		rounding         = 10,
		active_opacity   = 1.0,
		inactive_opacity = 0.97,
		shadow = {
			enabled = false,
			range   = 0,
		},
		blur = {
			enabled          = true,
			xray             = true,
			new_optimizations = true,
			size             = 2,
			brightness       = 1.01,
			passes           = 1,
			vibrancy         = 0.17,
		},
	},
	animations = {
		enabled = false,
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo   = true,
		font_family             = "JetbrainsMono Nerd",
	},
	input = {
		kb_layout    = "pl",
		follow_mouse = 1,
		repeat_rate  = 40,
		repeat_delay = 200,
		scroll_factor = 2.0,
		sensitivity  = 0,
		touchpad = {
			disable_while_typing = true,
			natural_scroll       = true,
		},
	},
	cursor = {
		no_hardware_cursors = true,
	},
})

-- ============================================================
-- GESTURES
-- ============================================================
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ============================================================
-- PER-DEVICE
-- ============================================================
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- ============================================================
-- KEYBINDINGS
-- ============================================================
local mainMod = "SUPER"

-- Applications
hl.bind(mainMod .. " + Q",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",     hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B",     hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + N",     hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + U",     hl.dsp.exec_cmd("kitty yazi"))
hl.bind(mainMod .. " + Y",     hl.dsp.exec_cmd(
	"pkill -x wofi || cliphist list | wofi --show dmenu --prompt 'Clipboard' --width 820 --height 400 --lines 9 | cliphist decode | wl-copy"
))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/.config/hypr/scripts/powermenu.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("pgrep waybar && pkill waybar || waybar &"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("~/.config/hypr/scripts/random-wallpaper.sh"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/remove_window_gaps.sh"))

-- Window management
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Screenshots (fire on key release)
hl.bind(mainMod .. " + S",
	hl.dsp.exec_cmd("bash -c 'slurp -d | grim -g - - | wl-copy && notify-send -u low \"Area screenshot copied to clipboard\" -t 2000'"),
	{ release = true }
)
hl.bind(mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd('bash -c \'TMP=$(mktemp /tmp/screenshot-XXXXXX.png); slurp -d | grim -g - "$TMP" && wl-copy < "$TMP" && swappy -f "$TMP" && rm "$TMP" && notify-send -u low "Annotated screenshot copied to clipboard" -t 2000\''),
	{ release = true }
)
hl.bind(mainMod .. " + CTRL + S",
	hl.dsp.exec_cmd('bash -c \'SCREENSHOT="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"; grim "$SCREENSHOT" && wl-copy < "$SCREENSHOT" && notify-send -u low "Screenshot saved to ~/Pictures/ and copied to clipboard" -t 2000\''),
	{ release = true }
)
hl.bind(mainMod .. " + ALT + S",
	hl.dsp.exec_cmd('bash -c \'SCREENSHOT="$HOME/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"; slurp -d | grim -g - "$SCREENSHOT" && wl-copy < "$SCREENSHOT" && notify-send -u low "Area screenshot saved to ~/Pictures/ and copied to clipboard" -t 2000\''),
	{ release = true }
)

-- Focus movement
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L",     hl.dsp.focus({ direction = "right" }))

-- Resize (repeating)
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -25"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 25 0"),   { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 25"),   { repeating = true })
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive -25 0"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -25"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.exec_cmd("hyprctl dispatch resizeactive 25 0"),   { repeating = true })
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 25"),   { repeating = true })
hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.exec_cmd("hyprctl dispatch resizeactive -25 0"),  { repeating = true })

-- Workspaces
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i,           hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i,   hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0",         hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mouse window ops
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume and media
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"),                     { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"),                     { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pamixer --default-source -t"),      { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer -t"),                       { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"),             { locked = true })
hl.bind("XF86AudioStop",        hl.dsp.exec_cmd("playerctl stop"),                   { locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"),             { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),                   { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),               { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +10%"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true })

-- ============================================================
-- WINDOW RULES
-- ============================================================
hl.window_rule({
	name  = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name  = "fix-xwayland-drags",
	match = {
		class      = "^$",
		title      = "^$",
		xwayland   = true,
		float      = true,
		fullscreen = false,
		pin        = false,
	},
	no_focus = true,
})

hl.window_rule({
	name  = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move  = "20 monitor_h-120",
	float = true,
})
