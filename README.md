# Hyprland Setup

> My personal Hyprland configuration for Arch Linux — opinionated, minimal.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Install Essential Packages](#2-install-essential-packages)
3. [Clone Dotfiles](#3-clone-dotfiles)
4. [Post-install Configuration](#4-post-install-configuration)
5. [Reboot](#5-reboot)
6. [Notes](#6-notes)

---

## 1. Prerequisites

Install `git`, `base-devel`, and the AUR helper `yay`:

```bash
sudo pacman -S git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

---

## 2. Install Essential Packages

```bash
yay -S \
    awww \
    bat \
    btop \
    bluez \
    bluez-utils \
    blueman \
    brightnessctl \
    cliphist \
    eza \
    fd \
    fzf \
    ffmpegthumbnailer \
    grim \
    hyprlock \
    hyprland \
    hypridle \
    hyprsunset \
    jq \
    kitty \
    libnotify \
    mako \
    neovim \
    nwg-look \
    networkmanager \
    nvidia-utils \
    nvidia-settings \
    nvidia-open-dkms \
    nm-connection-editor \
    pipewire \
    poppler \
    playerctl \
    pavucontrol \
    pipewire-alsa \
    pipewire-pulse \
    polkit-kde-agent \
    qutebrowser \
    qt5-wayland \
    qt6-wayland \
    rofi-calc \
    ripgrep \
    rofi-wayland \
    slurp \
    starship \
    tmux \
    ttf-jetbrains-mono-nerd \
    waybar \
    wireplumber \
    wl-clipboard \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland \
    zsh \
    zoxide
```

---

## 3. Clone Dotfiles

```bash
git clone https://github.com/Dessemy/dotfiles.git
```

Then symlink or copy the relevant configs into `~/.config/`.

---

## 4. Post-install Configuration

### Enable Services & Set Default Shell

```bash
chmod +x ~/.config/rofi/scripts/*
chsh -s /usr/bin/zsh
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager
systemctl --user enable --now polkit-kde-authentication-agent-1
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### Create Required Directories

```bash
mkdir -p ~/.local/state/zsh
mkdir -p ~/.cache/zsh
```

### Configure ZSH Environment

Edit `/etc/zsh/zshenv` as root to set XDG-compliant paths:

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

---

## 5. Reboot

```bash
reboot
```

---

## 6. Notes

- This setup an **NVIDIA GPU**. Adjust or remove the `nvidia-*` packages if you're on AMD/Intel.
