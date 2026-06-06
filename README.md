# Hyprland Setup

> My personal Hyprland configuration for Arch Linux — opinionated, and minimal.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Install Packages](#2-install-packages)
   - [Core — Hyprland & Wayland](#core--hyprland--wayland)
   - [Display & Graphics](#display--graphics)
   - [Audio](#audio)
   - [Bluetooth](#bluetooth)
   - [Networking](#networking)
   - [Terminal & Shell](#terminal--shell)
   - [Fonts](#fonts)
   - [Utilities](#utilities)
   - [Media](#media)
3. [Enable Services](#3-enable-services)
4. [Setup Dotfiles](#4-setup-dotfiles)
5. [Configure ZSH](#5-configure-zsh)
6. [Notes](#6-notes)

---

## 1. Prerequisites

Install `git`, `base-devel`, and the AUR helper `yay`:

```bash
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

---

## 2. Install Packages

### Core — Hyprland & Wayland

```bash
yay -S \
    hyprland \
    hyprlock \
    hypridle \
    hyprsunset \
    hyprpicker \
    waybar \
    rofi-wayland \
    rofi-calc \
    mako \
    awww \
    ly \
    polkit-kde-agent \
    xdg-utils \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland
```

### Display & Graphics

> ⚠️ NVIDIA only. See [Notes](#6-notes).

```bash
yay -S \
    nvidia-open-dkms \
    libva-nvidia-driver \
    dkms
```

### Audio

```bash
yay -S \
    pipewire \
    pipewire-audio \
    pipewire-jack \
    pipewire-alsa \
    pipewire-pulse \
    wireplumber \
    pavucontrol \
    playerctl
```

### Bluetooth

```bash
yay -S \
    bluez \
    bluez-utils \
    blueman
```

### Networking

```bash
yay -S \
    networkmanager \
    nm-connection-editor \
    openssh
```

### Terminal & Shell

```bash
yay -S \
    kitty \
    zsh \
    starship \
    tmux \
    zoxide
```

### Fonts

```bash
yay -S \
    ttf-jetbrains-mono-nerd \
    noto-fonts-cjk \
    noto-fonts \
    noto-fonts-emoji
```

### Utilities

```bash
yay -S \
    neovim \
    bat \
    btop \
    brightnessctl \
    cliphist \
    eza \
    fd \
    fzf \
    grim \
    slurp \
    imv \
    jq \
    nwg-look \
    ripgrep \
    smartmontools \
    wl-clipboard \
    wget
```

### Media

```bash
yay -S \
    mpv \
    ffmpegthumbnailer \
    poppler
```

---

## 3. Enable Services

Enable system and user services after installation:

```bash
# System services
sudo systemctl enable ly
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager

# User services
systemctl --user enable --now polkit-kde-authentication-agent-1
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

Then reboot to enter Hyprland via `ly`:

```bash
reboot
```

---

## 4. Setup Dotfiles

Clone and apply the dotfiles:

```bash
git clone https://github.com/Dessemy/dotfiles.git ~/dotfiles
cp -r ~/dotfiles/.config/* ~/.config/
cp -r ~/dotfiles/Pictures/* ~/Pictures/
chmod +x ~/.config/rofi/scripts/*
```

---

## 5. Configure ZSH

### Set ZSH as default shell

```bash
chsh -s /usr/bin/zsh
```

### Set XDG-compliant ZDOTDIR

Edit `/etc/zsh/zshenv` as root:

```bash
sudo nvim /etc/zsh/zshenv
```

Add the following:

```bash
if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

### Create required directories

```bash
mkdir -p ~/.local/state/zsh
mkdir -p ~/.cache/zsh
```

Then reboot:

```bash
reboot
```

---

## 6. Notes

- This setup an **NVIDIA GPU**. Adjust the `nvidia-*`, packages if you're on AMD/Intel.
