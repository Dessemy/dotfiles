local mainMod   = "SUPER"
local secondMod = "SUPER + SHIFT"

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod   .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(secondMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("qutebrowser"))
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd("~/.config/rofi/scripts/wifi-manager"))
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("~/.config/rofi/scripts/wallpaper-switcher"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/rofi/scripts/power-manager"))
hl.bind(mainMod .. " + Space",  hl.dsp.exec_cmd("rofi -show drun -theme ~/.config/rofi/config.rasi"))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd("rofi -show av-recorder -theme ~/.config/rofi/common.rasi"))
hl.bind(mainMod .. " + A",      hl.dsp.exec_cmd("rofi -show audio-output -theme ~/.config/rofi/microphone.rasi"))
hl.bind(mainMod .. " + I",      hl.dsp.exec_cmd("rofi -show microphone -theme ~/.config/rofi/microphone.rasi"))
hl.bind(mainMod .. " + P",      hl.dsp.exec_cmd("rofi -show performance-profile -theme ~/.config/rofi/performance-profile.rasi"))
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd("bash -c 'cliphist list | rofi -dmenu -theme ~/.config/rofi/config.rasi | cliphist decode | wl-copy'"))
hl.bind(mainMod .. " + S",      hl.dsp.exec_cmd("grim ~/Pictures/$(date +%Y%m%d_%H%M%S).png"))
hl.bind(secondMod .. " + S",    hl.dsp.exec_cmd("grim -g "$(slurp)" ~/Pictures/$(date +%Y%m%d_%H%M%S).png"))

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
