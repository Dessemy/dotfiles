# Hyprland Setup
> My Hypr

---

## Table of contents

1. [First thing first](#1-first-thing-first)
2. [Essential](#2-essential)
3. [Almost done](#3-almost-done)
4. [Get dotfiles](#4-get-dotfiles)
5. [Done](#5-done)
6. [Note](#6-note)

---

## 1. First thing first

```bash
sudo pacman -S git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

---

## 2. Essential

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
    zoxide \
```

---

## 3. Almost done

```bash
chsh -s /usr/bin/zsh
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager
systemctl --user enable --now polkit-kde-authentication-agent-1
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

---

## 4. Get dotfiles

```bash
git clone https://github.com/Dessemy/dotfiles
```

---

## 5. Done

```bash
reboot
```

---

## 6. Note
I use Arch BTW -_-
