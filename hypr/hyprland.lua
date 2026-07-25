--Monitors
hl.monitor({
  output   = "eDP-1",
  mode     = "1920x1080@60",
  position = "0x0",
  scale    = "1.0",
})

--Autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("~/.config/scripts/walls")
  hl.exec_cmd("hyprpolkitagent")
  hl.exec_cmd("wl-paste --type text  --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

--Environment
hl.env("GDK_SCALE", "1")
hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1.25")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("WLR_DRM_DEVICES", "/dev/dri/card0")

--LookNfeel
hl.config({
  general = {
    gaps_in          = 5,
    gaps_out         = 10,
    border_size      = 2,

    col              = {
      active_border   = "rgb(cba6f7)",
      inactive_border = "rgba(313244ff)",
    },

    resize_on_border = false,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = 0,
    rounding_power   = 0,

    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow           = {
      enabled = false,
    },

    blur             = {
      enabled = false,
    },
  },

  animations = {
    enabled = false,
  },
})

hl.config({
  dwindle = {
    preserve_split = true,
  },
})

hl.config({
  master = {
    new_status = "master",
  },
})

hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
  },
})

local suppressMaximizeRule = hl.window_rule({
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

--Misc
hl.config({
  misc = {
    force_default_wallpaper         = 0,
    disable_hyprland_logo           = true,
    disable_splash_rendering        = true,
    disable_hyprland_guiutils_check = true,
  },
})

--Input
hl.config({
  input = {
    kb_layout    = "us",

    follow_mouse = 1,

    sensitivity  = 0,

    touchpad     = {
      natural_scroll = true,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

--Binds
for i = 1, 10 do
  key = i % 10
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprpicker"))
hl.bind("SUPER + Q", hl.dsp.exec_cmd("qutebrowser"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("foot -e nvim"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd("foot -e yazi"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("foot -e rmpc"))
hl.bind("SUPER + O", hl.dsp.exec_cmd("foot -e btop"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("foot -e cava"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("foot -e bluetui"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("foot -e ttyper"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("foot -e wiremix"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("foot -e impala"))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("~/.config/scripts/fuzl"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("~/.config/scripts/wybr"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("~/.config/scripts/pwrswtcr"))
hl.bind("SUPER + W + RIGHT", hl.dsp.exec_cmd("~/.config/scripts/wallswtcr next"))
hl.bind("SUPER + W + LEFT", hl.dsp.exec_cmd("~/.config/scripts/wallswtcr prev"))
hl.bind("SUPER + ALT + C",
  hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --prompt 'Clipboard > ' | cliphist decode | wl-copy"))
hl.bind("SUPER + S",
  hl.dsp.exec_cmd(
    "bash -c 'grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send \"Screenshot\" \"Fullscreen saved\" -i camera-photo'"))
hl.bind("SUPER + CTRL + S",
  hl.dsp.exec_cmd(
    "bash -c 'grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send \"Screenshot\" \"Area saved\" -i camera-photo'"))
hl.bind("SUPER + SHIFT + S",
  hl.dsp.exec_cmd(
    "bash -c 'grim -g \"$(hyprctl activewindow -j | jq -r \".at[0],\\\"\\\",.at[1],\\\" \\\",(.size[0]),\\\"x\\\",.size[1]\" | tr -d \\\"\\n\\\")\" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send \"Screenshot\" \"Window saved\" -i camera-photo'"))

hl.bind("SUPER + CTRL + C", hl.dsp.window.close())
hl.bind("SUPER + CTRL + P", hl.dsp.window.pseudo())

hl.bind("SUPER + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

hl.bind("SUPER + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
