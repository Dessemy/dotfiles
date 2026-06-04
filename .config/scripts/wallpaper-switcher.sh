#!/usr/bin/env bash

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
ROFI_THEME="$HOME/.config/rofi/config.rasi"

WALLS=()
while IFS= read -r -d '' file; do
    WALLS+=("$file")
done < <(find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" \
    -o -iname "*.png" -o -iname "*.webp" \
    -o -iname "*.bmp" \
\) -print0 | sort -z)

[[ ${#WALLS[@]} -eq 0 ]] && exit 1

LIST=""
for img in "${WALLS[@]}"; do
    LIST+="$(basename "$img")\n"
done

CHOSEN=$(printf "%b" "$LIST" | rofi \
    -dmenu \
    -i \
    -p "  wallpapers" \
    -theme "$ROFI_THEME")

[[ -z "$CHOSEN" ]] && exit 0

for img in "${WALLS[@]}"; do
    if [[ "$(basename "$img")" == "$CHOSEN" ]]; then
        awww img "$img"
        exit 0
    fi
done
