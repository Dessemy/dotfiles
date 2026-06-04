> My hyprland setup

---

## Base

# Base tools
sudo pacman -S sudo pacman -S git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Driver
sudo pacman -S nvidia nvidia-utils nvidia-settings libva-nvidia-driver

# Wayland shi
sudo pacman -S wayland wayland-protocols xorg-xwayland qt5-wayland qt6-wayland

---

## Installing shi

# Essential
sudo pacman -S \
    hyprland \
    hyprlock \
    hypridle \
    hyprsunset \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    polkit-kde-agent \
    waybar \
    mako \
    libnotify \
    awww \
    grim \
    slurp \
    wl-clipboard \
    cliphist \
    kitty \
    zsh \
    starship \
    eza \
    bat \
    zoxide \
    fzf \
    btop \
    yazi \
    ttf-jetbrains-mono-nerd \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    pavucontrol
    ffmpegthumbnailer \
    unar \
    jq \
    poppler \
    fd \
    ripgrep \
    brightnessctl \
    playerctl \
    papirus-icon-theme \
    ly \
    networkmanager \
    nm-connection-editor \
    bluez \
    bluez-utils \
    blueman \
    qutebrowser

## Setup Shell

# Set zsh as a default
chsh -s /usr/bin/zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-completions
git clone https://github.com/zsh-users/zsh-completions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

---

## Essential AUR Package

# yeauy
yay -S \
    rofi-wayland \
    qt6ct

---

## Activating Services

# Pipewire audio
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Network
sudo systemctl enable --now NetworkManager

# Display Manager
sudo systemctl enable ly

# Bluetooth
sudo systemctl enable --now bluetooth

# Polkit
systemctl --user enable --now polkit-kde-authentication-agent-1

---

## Copy the dotfile

# Dotfile
cp dotfiles         ~/

---

## Note
I use Arch BTW -_-
