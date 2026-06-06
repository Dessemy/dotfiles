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
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
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

### Networking

```bash
yay -S \
    nm-connection-editor \
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
#
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
    ffmpegthumbnailer \
    poppler
```

---

## 4. Setup Dotfiles

Clone and apply the dotfiles:

```bash
git clone https://github.com/Dessemy/dotfiles.git ~/dotfiles
rm -rf ~/.config
cp -r ~/dotfiles/.config/* ~/.config/
chmod +x ~/.config/rofi/scripts/*
```

---

## 5. Configure ZSH

### Create required directories

```bash
mkdir -p ~/.local/state/zsh
mkdir -p ~/.cache/zsh
```

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

Then reboot:

```bash
reboot
```

---

## 6. Notes
