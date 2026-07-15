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
    hyprland yazi grim btop slurp foot neovim openssh wget \
    hyprpolkitagent qt5-wayland qt6-wayland smartmontools \
    xdg-desktop-portal-hyprland fuzzel waybar mako fastfetch zsh starship zoxide \
    brightnessctl herdr-bin hypridle hyprlock hyprsunset hyprpicker fzf eza bat mpv \
    libnotify ttf-firacode-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji \
    jq wl-clipboard wf-recorder mpd playerctl hyprpaper zip unzip steam \
    qutebrowser seatd ripgrep reflector nwg-look cliphist imagemagick fd ffmpeg \
    7zip ly switcheroo-control wiremix nodejs npm bluetui impala

log "Removing pre-existing nvidia-open (conflicts with nvidia-open-dkms)"
if pacman -Qq nvidia-open &>/dev/null; then
    sudo pacman -Rdd --noconfirm nvidia-open 2>/dev/null || true
fi

log "Installing AMD and Nvidia (open kernel module, dkms) drivers"
sudo pacman -S --needed --noconfirm \
    mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
    vulkan-icd-loader lib32-vulkan-icd-loader \
    nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
    
log "Regenerating initramfs for linux-zen"
sudo mkinitcpio -P

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

log "Making scripts executable"
chmod +x "$HOME/.config/scripts/cputemp" 2>/dev/null || warn "cputemp not found in ~/.config/scripts, skipping chmod"
chmod +x "$HOME/.config/scripts/wallswitcher" 2>/dev/null || warn "wallswitcher not found in ~/.config/scripts, skipping chmod"
chmod +x "$HOME/.config/scripts/walls" 2>/dev/null || warn "walls not found in ~/.config/scripts, skipping chmod"

if [[ -d "$SCRIPT_DIR/scripts" ]]; then
    log "Adding $SCRIPT_DIR/scripts to PATH via /etc/zsh/zshenv"
    if ! grep -q "dotfiles/scripts" "$ZSHENV" 2>/dev/null; then
        echo "export PATH=\"$SCRIPT_DIR/scripts:\$PATH\"" | sudo tee -a "$ZSHENV" > /dev/null
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
