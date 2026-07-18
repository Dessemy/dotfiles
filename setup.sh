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
    brightnessctl playerctl reflector libnotify libqalculate switcheroo-control wl-clipboard wf-recorder cliphist \
    foot herdr-bin neovim yazi bluetui impala wiremix btop ttyper mpv mpd 7zip zip unzip \
    zsh starship zoxide jq fd fzf fastfetch eza bat ripgrep imagemagick ffmpeg \
    ttf-firacode-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji \
    hyprlock hyprsunset hyprpicker hyprpaper hyprpolkitagent \
    qutebrowser vesktop-bin steam lutris \
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
    RAM_GIB=$(( (RAM_KIB + 1048575) / 1048576 ))  # round up to nearest GiB
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

log "Configuring iwd (WiFi) for automatic DHCP"
IWD_CONF="/etc/iwd/main.conf"
sudo mkdir -p /etc/iwd
if [[ ! -f "$IWD_CONF" ]]; then
    sudo tee "$IWD_CONF" > /dev/null <<'EOF'
[General]
EnableNetworkConfiguration=true
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

log "Setup complete. Rebooting in 3 seconds — press Ctrl+C now to cancel."
sleep 3
sudo reboot
