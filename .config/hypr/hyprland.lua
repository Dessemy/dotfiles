# Monitors
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "0.75",
})

# Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

# Environment
hl.env("XCURSOR_SIZE", "24")
hl.env("GDK_BACKEND",    "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",    "1.25")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME",           "qt6ct")
hl.env("LIBVA_DRIVER_NAME",       "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

# LookNfeel
hl.config({
    general = {
        gaps_in  = 10,
        gaps_out = 15,

        border_size = 5,

        col = {
            active_border   = "rgb(798186)",
            inactive_border = "rgba(343d41ff)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 5,

        active_opacity   = 0.7,
        inactive_opacity = 0.7,

        shadow = {
            enabled      = false,
            range        = 20,
            render_power = 3,
            color        = 0xee101315,
        },

        blur = {
            enabled  = false,
            size     = 20,
            passes   = 3,
            vibrancy = 0.1696,
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

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })
hl.curve("easeInOutQuart", { type = "bezier", points = { { 0.76, 0 },    { 0.24, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 75.2633, dampening = 15.8273644 })
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 3.39, bezier = "quick" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.5,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 4.5,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, spring = "easy" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    spring = "easy",         style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  spring = "easy",         style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

local suppressMaximizeRule = hl.window_rule({
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

# Misc
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

# Input
hl.config({
    input = {
        kb_layout  = "us",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

# Binds
local mainMod   = "SUPER"
local secondMod = "SUPER + SHIFT"
local thirdMod = "SUPER + CTRL"

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod   .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(secondMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("qutebrowser"))
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd("~/.config/scripts/wifi-manager"))
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("~/.config/scripts/wallpaper-switcher"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/scripts/power-manager"))
hl.bind(secondMod .. " + T",    hl.dsp.exec_cmd("~/.config/scripts/theme-switcher"))
hl.bind(mainMod .. " + Space",  hl.dsp.exec_cmd("rofi -show drun -theme ~/.config/rofi/config.rasi"))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd("rofi -show av-recorder -theme ~/.config/rofi/common.rasi"))
hl.bind(mainMod .. " + A",      hl.dsp.exec_cmd("rofi -show audio-output -theme ~/.config/rofi/microphone.rasi"))
hl.bind(mainMod .. " + I",      hl.dsp.exec_cmd("rofi -show microphone -theme ~/.config/rofi/microphone.rasi"))
hl.bind(mainMod .. " + P",      hl.dsp.exec_cmd("rofi -show performance-profile -theme ~/.config/rofi/performance-profile.rasi"))
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd("bash -c 'cliphist list | rofi -dmenu -theme ~/.config/rofi/config.rasi | cliphist decode | wl-copy'"))
hl.bind(mainMod .. " + S",      hl.dsp.exec_cmd("bash -c 'grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send \"Screenshot\" \"Fullscreen saved\" -i camera-photo'"))
hl.bind(thirdMod .. " + S",     hl.dsp.exec_cmd("bash -c 'grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send \"Screenshot\" \"Area saved\" -i camera-photo'"))
hl.bind(secondMod .. " + S",    hl.dsp.exec_cmd("bash -c 'grim -g \"$(hyprctl activewindow -j | jq -r \".at[0],\\\"\\\",.at[1],\\\" \\\",(.size[0]),\\\"x\\\",.size[1]\" | tr -d \\\"\\n\\\")\" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send \"Screenshot\" \"Window saved\" -i camera-photo'"))

hl.bind(secondMod .. " + Q", hl.dsp.window.close())
hl.bind(secondMod .. " + P", hl.dsp.window.pseudo())

hl.bind(secondMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(secondMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(secondMod .. " + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(secondMod .. " + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(secondMod .. " + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(secondMod .. " + J", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod   .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(secondMod .. " + M", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })
