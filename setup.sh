#!/usr/bin/env bash

set -euo pipefail

log() { echo -e "\n\033[1;32m==>\033[0m $1"; }
warn() { echo -e "\n\033[1;33m!!\033[0m $1"; }

if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script as root. Run it as your normal user; it will call sudo when needed."
    exit 1
fi

log "Updating system and installing linux-zen kernel"
sudo pacman -Syu --needed --noconfirm linux-zen linux-zen-headers

log "Enabling multilib repository"
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    sudo sed -i "/^#\[multilib\]/,/^#Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Sy
else
    log "multilib already enabled"
fi

log "Installing base-devel"
sudo pacman -S --needed --noconfirm base-devel

if ! command -v yay &>/dev/null; then
    log "Building and installing yay-bin"
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
else
    log "yay already installed, skipping"
fi

log "Installing desktop and CLI packages via yay"
yay -S --needed --noconfirm \
    ly seatd hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland smartmontools grim slurp nodejs npm openssh wget \
    brightnessctl playerctl reflector libnotify libqalculate switcheroo-control wl-clipboard cliphist cpupower \
    foot herdr-bin neovim yazi bluetui impala wiremix btop cava ttyper mpv rmpc mpc mpd 7zip zip unzip \
    zsh starship zoxide jq fd fzf fastfetch eza bat ripgrep imagemagick ffmpeg \
    ttf-firacode-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji \
    hyprlock hyprsunset hyprpicker hyprpaper hyprpolkitagent \
    qutebrowser obs-studio vesktop-bin freedownloadmanager steam lutris \
    fuzzel waybar mako nwg-look

log "Removing pre-existing nvidia-open (conflicts with nvidia-open-dkms)"
if pacman -Qq nvidia-open &>/dev/null; then
    sudo pacman -Rdd --noconfirm nvidia-open 2>/dev/null || true
fi

log "Installing AMD and Nvidia (open kernel module, dkms) drivers"
sudo pacman -S --needed --noconfirm \
    mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
    vulkan-icd-loader lib32-vulkan-icd-loader \
    nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
    
log "Removing splash logo from linux-zen UKI preset"
PRESET_FILE="/etc/mkinitcpio.d/linux-zen.preset"
if [[ -f "$PRESET_FILE" ]] && grep -q -- "--splash" "$PRESET_FILE"; then
    sudo sed -i 's|default_options="--splash [^"]*"|default_options=""|' "$PRESET_FILE"
else
    log "No splash option found in $PRESET_FILE, skipping"
fi

log "Setting up hibernation support (swapfile + resume)"
SWAPFILE="/swapfile"

if swapon --show=NAME --noheadings 2>/dev/null | grep -qx "$SWAPFILE"; then
    log "Swapfile already active, skipping creation"
elif [[ -f "$SWAPFILE" ]]; then
    log "Swapfile already exists at $SWAPFILE, activating"
    sudo swapon "$SWAPFILE" || true
else
    RAM_KIB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    RAM_GIB=$(( (RAM_KIB + 1048575) / 1048576 ))
    log "Creating ${RAM_GIB}GiB swapfile at $SWAPFILE (sized to match RAM)"
    sudo fallocate -l "${RAM_GIB}G" "$SWAPFILE"
    sudo chmod 600 "$SWAPFILE"
    sudo mkswap "$SWAPFILE"
    sudo swapon "$SWAPFILE"
fi

if ! grep -q "^$SWAPFILE " /etc/fstab 2>/dev/null; then
    echo "$SWAPFILE none swap defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
fi

log "Calculating swapfile resume_offset"
SWAP_OFFSET=$(sudo filefrag -v "$SWAPFILE" | awk '$1=="0:" {print $4}' | tr -d '.')
ROOT_DEV=$(findmnt -no SOURCE /)
ROOT_UUID=$(sudo blkid -s UUID -o value "$ROOT_DEV")

if [[ -z "$SWAP_OFFSET" || -z "$ROOT_UUID" ]]; then
    warn "Could not determine swap offset or root UUID, skipping resume kernel params (hibernate will not work until this is fixed manually)"
else
    RESUME_PARAMS="resume=UUID=$ROOT_UUID resume_offset=$SWAP_OFFSET"

    log "Adding 'resume' hook to /etc/mkinitcpio.conf"
    if ! grep -qE '^HOOKS=.*\bresume\b' /etc/mkinitcpio.conf; then
        sudo sed -i -E 's/^(HOOKS=\([^)]*\budev\b)/\1 resume/' /etc/mkinitcpio.conf
    else
        log "resume hook already present, skipping"
    fi

    CMDLINE_FILE="/etc/kernel/cmdline"
    if [[ -f "$CMDLINE_FILE" ]]; then
        log "Adding resume params to $CMDLINE_FILE (UKI cmdline)"
        if ! grep -q "resume=" "$CMDLINE_FILE"; then
            sudo sed -i "s|\$| $RESUME_PARAMS|" "$CMDLINE_FILE"
        else
            log "resume params already present in $CMDLINE_FILE, skipping"
        fi
    else
        log "No $CMDLINE_FILE found, adding resume params to systemd-boot entries instead"
        shopt -s nullglob
        for entry in /boot/loader/entries/*.conf; do
            if ! grep -q "resume=" "$entry"; then
                sudo sed -i "/^options/ s|\$| $RESUME_PARAMS|" "$entry"
                log "  updated $entry"
            fi
        done
        shopt -u nullglob
    fi
fi

log "Regenerating initramfs for linux-zen"
sudo mkinitcpio -P

log "Disabling systemd-boot menu (timeout 0)"
LOADER_CONF="/boot/loader/loader.conf"
if [[ -f "$LOADER_CONF" ]]; then
    if grep -q "^timeout" "$LOADER_CONF"; then
        sudo sed -i 's/^timeout.*/timeout 0/' "$LOADER_CONF"
    else
        echo "timeout 0" | sudo tee -a "$LOADER_CONF" > /dev/null
    fi
    sudo bootctl set-timeout 0 2>/dev/null || true
else
    warn "$LOADER_CONF not found, skipping systemd-boot timeout config"
fi

log "Enabling zsh shell"
sudo chsh -s /usr/bin/zsh "$USER"

log "Configuring /etc/zsh/zshenv (XDG_CONFIG_HOME / ZDOTDIR)"
ZSHENV="/etc/zsh/zshenv"
sudo touch "$ZSHENV"
if ! grep -q "XDG_CONFIG_HOME" "$ZSHENV" 2>/dev/null; then
    sudo tee -a "$ZSHENV" > /dev/null <<'EOF'

if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
EOF
else
    log "zshenv already configured, skipping"
fi

log "Creating Pictures and Downloads"
mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Pictures/Screenshots" "$HOME/Downloads"

log "Copying dotfiles configs into ~/.config"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIRS=(btop fastfetch foot fuzzel herdr hypr mako qutebrowser scripts waybar yazi nvim zsh)
mkdir -p "$HOME/.config"
for dir in "${CONFIG_DIRS[@]}"; do
    if [[ -d "$SCRIPT_DIR/$dir" ]]; then
        cp -r "$SCRIPT_DIR/$dir" "$HOME/.config/$dir"
        log "  copied $dir -> ~/.config/$dir"
    else
        warn "Config folder '$dir' not found next to setup.sh (expected $SCRIPT_DIR/$dir), skipping"
    fi
done

log "Making all scripts in ~/.config/scripts executable"
if [[ -d "$HOME/.config/scripts" ]]; then
    chmod +x "$HOME/.config/scripts"/*
else
    warn "~/.config/scripts not found, skipping chmod"
fi

if [[ -d "$HOME/.config/scripts" ]]; then
    log "Adding ~/.config/scripts to PATH via /etc/zsh/zshenv"
    if ! grep -q ".config/scripts" "$ZSHENV" 2>/dev/null; then
        echo 'export PATH="$HOME/.config/scripts:$PATH"' | sudo tee -a "$ZSHENV" > /dev/null
    fi
fi

log "Setting up battery-notify systemd user timer"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_USER_DIR"

if [[ -f "$HOME/.config/scripts/battery-notify.sh" ]]; then
    cat > "$SYSTEMD_USER_DIR/battery-notify.service" <<'EOF'
[Unit]
Description=Battery percentage notification

[Service]
Type=oneshot
ExecStart=%h/.config/scripts/batnotify
EOF

    cat > "$SYSTEMD_USER_DIR/battery-notify.timer" <<'EOF'
[Unit]
Description=Run battery percentage check every 60 seconds

[Timer]
OnBootSec=30sec
OnUnitActiveSec=60sec
AccuracySec=5sec

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now battery-notify.timer
    log "  battery-notify.timer enabled"
else
    warn "~/.config/scripts/batnotify not found, skipping battery-notify timer setup"
fi

log "Setting up CPU power profile switcher (performance/balanced/powersave)"
SCRIPTS_DIR="$HOME/.config/scripts"
mkdir -p "$SCRIPTS_DIR"

if [[ ! -f "$SCRIPTS_DIR/cpupower-switcher" ]]; then
    cat > "$SCRIPTS_DIR/cpupower-switcher" <<'SCRIPT_EOF'
#!/usr/bin/env bash

set -euo pipefail

STATE_FILE="/tmp/cpupower-switcher-current"

if ! command -v cpupower &> /dev/null; then
    notify-send -u critical "CPU Power" "cpupower tidak ditemukan. Install dulu: sudo pacman -S cpupower"
    exit 1
fi

AVAILABLE_GOVERNORS=$(cpupower frequency-info -g 2>/dev/null | grep -oP '(?<=governors: ).*' || true)

if echo "$AVAILABLE_GOVERNORS" | grep -qw schedutil; then
    BALANCED_GOVERNOR="schedutil"
elif echo "$AVAILABLE_GOVERNORS" | grep -qw ondemand; then
    BALANCED_GOVERNOR="ondemand"
else
    BALANCED_GOVERNOR="powersave"
fi

declare -A LABELS=(
    ["performance"]="Performance"
    ["balanced"]="Balanced (${BALANCED_GOVERNOR})"
    ["powersave"]="Power Saver"
)

set_mode() {
    local mode="$1"
    local governor="$mode"

    if [[ "$mode" == "balanced" ]]; then
        governor="$BALANCED_GOVERNOR"
    fi

    sudo cpupower frequency-set -g "$governor" &> /dev/null

    echo "$mode" > "$STATE_FILE"
    date +%s > /tmp/cpupower-manual-override
    notify-send -u normal "CPU Power Mode" "${LABELS[$mode]}" -t 1500

    pkill -RTMIN+8 waybar 2>/dev/null || true
}

CURRENT="balanced"
if [[ -f "$STATE_FILE" ]]; then
    CURRENT=$(cat "$STATE_FILE")
fi

if [[ $# -ge 1 ]]; then
    case "$1" in
        performance|balanced|powersave)
            set_mode "$1"
            ;;
        *)
            echo "Argumen tidak valid. Gunakan: performance | balanced | powersave"
            exit 1
            ;;
    esac
    exit 0
fi

case "$CURRENT" in
    performance) set_mode "balanced" ;;
    balanced)    set_mode "powersave" ;;
    powersave)   set_mode "performance" ;;
    *)           set_mode "balanced" ;;
esac
SCRIPT_EOF
    chmod +x "$SCRIPTS_DIR/cpupower-switcher"
    log "  created $SCRIPTS_DIR/cpupower-switcher"
else
    log "cpupower-switcher already exists, skipping"
fi

if [[ ! -f "$SCRIPTS_DIR/waybar-power-mode" ]]; then
    cat > "$SCRIPTS_DIR/waybar-power-mode" <<'SCRIPT_EOF'
#!/usr/bin/env bash

set -euo pipefail

STATE_FILE="/tmp/cpupower-switcher-current"
CURRENT="balanced"

if [[ -f "$STATE_FILE" ]]; then
    CURRENT=$(cat "$STATE_FILE")
fi

ACTUAL_GOVERNOR=$(cpupower frequency-info -p 2>/dev/null | grep -oP '(?<=governor ")[^"]+' || echo "unknown")

case "$CURRENT" in
    performance)
        ICON="󰓅"
        LABEL="Performance"
        CLASS="performance"
        ;;
    powersave)
        ICON="󰾆"
        LABEL="Power Saver"
        CLASS="powersave"
        ;;
    balanced|*)
        ICON="󰾅"
        LABEL="Balanced"
        CLASS="balanced"
        ;;
esac

TOOLTIP="Mode: ${LABEL}\nGovernor: ${ACTUAL_GOVERNOR}\nKlik untuk ganti mode"
TOOLTIP_JSON=$(echo "$TOOLTIP" | sed 's/$/\\n/' | tr -d '\n')

printf '{"text": "%s", "tooltip": "%s", "class": "%s", "alt": "%s"}\n' \
    "$ICON" "$TOOLTIP_JSON" "$CLASS" "$CURRENT"
SCRIPT_EOF
    chmod +x "$SCRIPTS_DIR/waybar-power-mode"
    log "  created $SCRIPTS_DIR/waybar-power-mode"
else
    log "waybar-power-mode already exists, skipping"
fi

log "Installing system-level cpupower-auto (AC/battery auto-switch) script"
if [[ ! -f /usr/local/bin/cpupower-auto.sh ]]; then
    sudo tee /usr/local/bin/cpupower-auto.sh > /dev/null <<'SCRIPT_EOF'
#!/usr/bin/env bash

set -euo pipefail

USB_EXCLUDE=()

set_usb_autosuspend() {
    local timeout="$1"
    for dev in /sys/bus/usb/devices/*/power/control; do
        [[ -e "$dev" ]] || continue
        local devdir
        devdir=$(dirname "$dev")
        local id_vendor id_product usb_id
        id_vendor=$(cat "$devdir/idVendor" 2>/dev/null || echo "")
        id_product=$(cat "$devdir/idProduct" 2>/dev/null || echo "")
        usb_id="${id_vendor}:${id_product}"

        local skip=0
        for excluded in "${USB_EXCLUDE[@]:-}"; do
            [[ "$usb_id" == "$excluded" ]] && skip=1 && break
        done
        [[ "$skip" -eq 1 ]] && continue

        if [[ "$timeout" -eq 0 ]]; then
            echo "on" > "$dev" 2>/dev/null || true
        else
            echo "auto" > "$dev" 2>/dev/null || true
            echo "$((timeout * 1000))" > "$devdir/power/autosuspend_delay_ms" 2>/dev/null || true
        fi
    done
}

set_pcie_aspm() {
    local policy="$1"
    if [[ -w /sys/module/pcie_aspm/parameters/policy ]]; then
        echo "$policy" > /sys/module/pcie_aspm/parameters/policy 2>/dev/null || true
    fi
}

STATE_FILE="/tmp/cpupower-switcher-current"
OVERRIDE_FILE="/tmp/cpupower-manual-override"

if [[ -f "$OVERRIDE_FILE" ]]; then
    LAST_OVERRIDE=$(cat "$OVERRIDE_FILE")
    NOW=$(date +%s)
    if (( NOW - LAST_OVERRIDE < 5 )); then
        exit 0
    fi
fi

AC_STATUS_PATH=$(find /sys/class/power_supply -maxdepth 1 -name "A*" | head -n1)

if [[ -z "$AC_STATUS_PATH" ]]; then
    exit 0
fi

ON_AC=$(cat "$AC_STATUS_PATH/online" 2>/dev/null || echo "1")

AVAILABLE_GOVERNORS=$(cpupower frequency-info -g 2>/dev/null | grep -oP '(?<=governors: ).*' || true)
if echo "$AVAILABLE_GOVERNORS" | grep -qw schedutil; then
    BALANCED_GOVERNOR="schedutil"
elif echo "$AVAILABLE_GOVERNORS" | grep -qw ondemand; then
    BALANCED_GOVERNOR="ondemand"
else
    BALANCED_GOVERNOR="powersave"
fi

notify_user() {
    local msg="$1"
    local target_user target_uid
    target_user="$(logname 2>/dev/null || echo "${SUDO_USER:-}")"
    [[ -z "$target_user" ]] && return 0
    target_uid=$(id -u "$target_user" 2>/dev/null || echo "")
    [[ -z "$target_uid" ]] && return 0
    sudo -u "$target_user" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${target_uid}/bus" \
        notify-send "Power Mode" "$msg" -t 2000 2>/dev/null || true
    sudo -u "$target_user" pkill -RTMIN+8 waybar 2>/dev/null || true
}

if [[ "$ON_AC" == "1" ]]; then
    cpupower frequency-set -g "$BALANCED_GOVERNOR" &> /dev/null
    set_usb_autosuspend 0
    set_pcie_aspm performance

    echo "balanced" > "$STATE_FILE"
    notify_user "AC connected -> Balanced. USB: full power, PCIe: performance"
else
    cpupower frequency-set -g "powersave" &> /dev/null
    set_usb_autosuspend 2
    set_pcie_aspm powersave

    echo "powersave" > "$STATE_FILE"
    notify_user "On battery -> Power Saver. USB: autosuspend, PCIe: powersave"
fi
SCRIPT_EOF
    sudo chmod +x /usr/local/bin/cpupower-auto.sh
    log "  created /usr/local/bin/cpupower-auto.sh"
else
    log "/usr/local/bin/cpupower-auto.sh already exists, skipping"
fi

log "Installing udev rule for AC plug/unplug auto power-switching"
UDEV_RULE="/etc/udev/rules.d/99-cpupower-auto.rules"
if [[ ! -f "$UDEV_RULE" ]]; then
    sudo tee "$UDEV_RULE" > /dev/null <<'EOF'
SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="/usr/local/bin/cpupower-auto.sh"
SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="/usr/local/bin/cpupower-auto.sh"
EOF
    sudo udevadm control --reload-rules
    log "  udev rule installed and reloaded"
else
    log "udev rule already exists, skipping"
fi

log "Granting passwordless sudo for cpupower frequency-set (needed for manual keybind switching)"
SUDOERS_FILE="/etc/sudoers.d/cpupower"
if [[ ! -f "$SUDOERS_FILE" ]]; then
    TMP_SUDOERS=$(mktemp)
    echo "$USER ALL=(root) NOPASSWD: /usr/bin/cpupower frequency-set*" > "$TMP_SUDOERS"
    if sudo visudo -cf "$TMP_SUDOERS"; then
        sudo install -m 0440 "$TMP_SUDOERS" "$SUDOERS_FILE"
        log "  sudoers rule installed at $SUDOERS_FILE"
    else
        warn "Generated sudoers rule failed validation, skipping (cpupower-switcher will prompt for password)"
    fi
    rm -f "$TMP_SUDOERS"
else
    log "sudoers rule for cpupower already exists, skipping"
fi

log "Running initial power-detection (sets governor/USB/PCIe based on current AC status)"
sudo /usr/local/bin/cpupower-auto.sh || warn "Initial cpupower-auto run failed, check manually after reboot"

log "Disabling rtw89 power save (fixes lag/disconnect on RTL8852BE/AE/CE wifi)"
RTW89_CONF="/etc/modprobe.d/rtw89.conf"
if lspci -k 2>/dev/null | grep -qi "rtw89"; then
    if [[ ! -f "$RTW89_CONF" ]] || ! grep -q "disable_ps_mode=1" "$RTW89_CONF" 2>/dev/null; then
        echo "options rtw89_core disable_ps_mode=1" | sudo tee "$RTW89_CONF" > /dev/null
        log "  rtw89 power save disabled, will take effect after reboot"
    else
        log "rtw89 power save already disabled, skipping"
    fi
else
    log "No rtw89 wifi device detected, skipping"
fi

log "Configuring iwd (WiFi) for automatic DHCP"
IWD_CONF="/etc/iwd/main.conf"
sudo mkdir -p /etc/iwd
if [[ ! -f "$IWD_CONF" ]]; then
    sudo tee "$IWD_CONF" > /dev/null <<'EOF'
[General]
EnableNetworkConfiguration=true

[Scan]
DisablePeriodicScan=true
EOF
elif ! grep -q "EnableNetworkConfiguration=true" "$IWD_CONF"; then
    if grep -q "^\[General\]" "$IWD_CONF"; then
        sudo sed -i '/^\[General\]/a EnableNetworkConfiguration=true' "$IWD_CONF"
    else
        printf "\n[General]\nEnableNetworkConfiguration=true\n" | sudo tee -a "$IWD_CONF" > /dev/null
    fi
else
    log "iwd already configured for DHCP, skipping"
fi

if ! grep -q "^\[Scan\]" "$IWD_CONF" 2>/dev/null; then
    printf "\n[Scan]\nDisablePeriodicScan=true\n" | sudo tee -a "$IWD_CONF" > /dev/null
elif ! grep -q "DisablePeriodicScan=true" "$IWD_CONF"; then
    sudo sed -i '/^\[Scan\]/a DisablePeriodicScan=true' "$IWD_CONF"
else
    log "iwd periodic scan already disabled, skipping"
fi

log "Making sure NetworkManager is disabled (standalone iwd setup, install may not even have it)"
if systemctl list-unit-files NetworkManager.service &>/dev/null; then
    sudo systemctl disable --now NetworkManager 2>/dev/null || true
else
    log "NetworkManager not installed, nothing to disable"
fi

log "Unblocking rfkill (in case it's blocked after install)"
sudo rfkill unblock all 2>/dev/null || true

log "Enabling iwd service"
sudo systemctl enable --now iwd

log "Enabling systemd-resolved (fix DNS for iwd connections)"
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

log "Enabling seatd service"
sudo systemctl enable --now seatd.service || true
sudo usermod -aG seat "$USER" || true

log "Enabling switcheroo-control.service"
sudo systemctl enable --now switcheroo-control.service

log "Disablling getty service"
sudo systemctl disable getty@tty1.service

log "Enabling ly.service"
sudo systemctl enable ly@tty1.service

log "Enabling reflector timer"
sudo systemctl enable --now reflector.timer || true

log "Setting up MPD (Music Player Daemon)"
MPD_CONFIG_DIR="$HOME/.config/mpd"
mkdir -p "$MPD_CONFIG_DIR/playlists" "$HOME/Music"

if [[ ! -f "$MPD_CONFIG_DIR/mpd.conf" ]]; then
    cat > "$MPD_CONFIG_DIR/mpd.conf" <<EOF
music_directory    "$HOME/Music"
playlist_directory "$MPD_CONFIG_DIR/playlists"
db_file            "$MPD_CONFIG_DIR/database"
log_file           "$MPD_CONFIG_DIR/log"
pid_file           "$MPD_CONFIG_DIR/pid"
state_file         "$MPD_CONFIG_DIR/state"
sticker_file       "$MPD_CONFIG_DIR/sticker.sql"

bind_to_address    "127.0.0.1"
port               "6600"
EOF
    log "  created $MPD_CONFIG_DIR/mpd.conf"
else
    log "mpd.conf already exists, skipping"
fi

log "Enabling mpd user service"
systemctl --user enable --now mpd

log "Generating default rmpc config and theme"
RMPC_CONFIG_DIR="$HOME/.config/rmpc"
mkdir -p "$RMPC_CONFIG_DIR"

if [[ ! -f "$RMPC_CONFIG_DIR/config.ron" ]]; then
    rmpc config > "$RMPC_CONFIG_DIR/config.ron"
    log "  created $RMPC_CONFIG_DIR/config.ron"
else
    log "rmpc config.ron already exists, skipping"
fi

if [[ ! -f "$RMPC_CONFIG_DIR/theme.ron" ]]; then
    rmpc theme > "$RMPC_CONFIG_DIR/theme.ron"
    log "  created $RMPC_CONFIG_DIR/theme.ron"
else
    log "rmpc theme.ron already exists, skipping"
fi

log "Note: album art in rmpc works via foot's native Sixel support, no extra image backend needed."

log "Setup complete. Rebooting in 3 seconds — press Ctrl+C now to cancel."
sleep 3
sudo reboot
