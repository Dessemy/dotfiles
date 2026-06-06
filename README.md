# Hyprland Setup

> My personal Hyprland configuration for Arch Linux — opinionated, and minimal.

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
    blueman \
    bluez-utils \
    brightnessctl \
    cliphist \
    dkms \
    eza \
    fd \
    fzf \
    ffmpegthumbnailer \
    grim \
    hyprlock \
    hyprland \
    hypridle \
    hyperpicker \
    hyprsunset \
    imv \
    jq \
    kitty \
    libva-nvidia-driver \
    mako \
    mpv \
    neovim \
    noto-fonts \
    noto-fonts-emoji \
    nwg-look \
    networkmanager \
    nvidia-open-dkms \
    nm-connection-editor \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    poppler \
    playerctl \
    pavucontrol \
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
    wget \
    waybar \
    wireplumber \
    wl-clipboard \
    xdg-desktop-portal-hyprland \
    xdg-utils \
    zsh \
    zoxide
```

### Enable Services

```bash
chsh -s /usr/bin/zsh
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager
systemctl --user enable --now polkit-kde-authentication-agent-1
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

```bash
reboot
```

---

## 3. Clone Dotfiles

```bash
git clone https://github.com/Dessemy/dotfiles.git ~/dotfiles
cp -r ~/dotfiles/.config/* ~/.config/
cp -r ~/dotfiles/Pictures/* ~/Pictures/
chmod +x ~/.config/rofi/scripts/*
```

---

## 4. Post-install Configuration



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

- This setup an **NVIDIA GPU**. Adjust or remove the `nvidia-*`, packages if you're on AMD/Intel.
