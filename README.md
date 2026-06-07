> My personal Hyprland configuration for Arch Linux — opinionated, and minimal.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Install Packages](#2-install-packages)
   - [Core — Hyprland & Wayland](#core--hyprland--wayland)
   - [Audio](#audio)
   - [Bluetooth](#bluetooth)
   - [Terminal & Shell](#terminal--shell)
   - [Fonts](#fonts)
   - [Utilities](#utilities)
   - [Media](#media)
3. [Setup Dotfiles](#3-setup-dotfiles)
4. [Configure ZSH](#4-configure-zsh)
5. [Notes](#5-notes)

---

## 1. Prerequisites

### Debloat

Remove packages that conflict with or are replaced by this setup:

```bash
sudo pacman -Rns dolphin dunst htop nano uwsm vim wofi
```

### Install Base Tools

Install `git`, `base-devel`, and the AUR helper `yay`:

```bash
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
```

---

## 2. Install Packages

### Core — Hyprland & Wayland

```bash
yay -S \
    hyprlock \
    hypridle \
    hyprsunset \
    hyprpicker \
    waybar \
    rofi-wayland \
    rofi-calc \
    mako \
    awww
```

### Audio

```bash
yay -S \
    pavucontrol
```

### Bluetooth

```bash
yay -S \
    blueman
```

### Terminal & Shell

```bash
yay -S \
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
    noto-fonts-emoji

# Refresh font cache
fc-cache -fv
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
    imv \
    jq \
    nwg-look \
    ripgrep \
    wl-clipboard
```

### Media

```bash
yay -S \
    mpv \
    ffmpegthumbnailer
```

---

## 3. Setup Dotfiles

Clone and apply the dotfiles:

```bash
git clone https://github.com/Dessemy/dotfiles.git ~/dotfiles
rm -rf ~/.config
```

```bash
cp -r ~/dotfiles/.config/* ~/.config/
chmod +x ~/.config/rofi/scripts/*
```

> **Warning:** This replaces your entire `~/.config` directory.

---

## 4. Configure ZSH

### Create Required Directories

```bash
mkdir -p ~/.local/state/zsh
mkdir -p ~/.cache/zsh
```

### Set ZSH as Default Shell

```bash
chsh -s /usr/bin/zsh
```

### Set XDG-Compliant ZDOTDIR

Edit `/etc/zsh/zshenv` as root:

```bash
sudo nvim /etc/zsh/zshenv
```

Add the following lines:

```bash
if [[ -z "$XDG_CONFIG_HOME" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

### Reboot

```bash
reboot
```

---

## 5. Notes
