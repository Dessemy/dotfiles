# Panduan Install Hyprland di Arch Linux
> Solitude setup — Hyprland · Waybar · Kitty · Rofi · Mako · Yazi · btop

---

## Daftar Isi

1. [Base System](#1-base-system)
2. [Driver & Display Server](#2-driver--display-server)
3. [Hyprland & Ekosistem](#3-hyprland--ekosistem)
4. [Terminal & Shell](#4-terminal--shell)
5. [Aplikasi Pendukung](#5-aplikasi-pendukung)
6. [AUR Packages](#6-aur-packages)
7. [Deploy Config Files](#7-deploy-config-files)
8. [Aktivasi Services](#8-aktivasi-services)
9. [Pertama Kali Login](#9-pertama-kali-login)
10. [Keybinds Referensi](#10-keybinds-referensi)

---

## 1. Base System

Pastikan Arch sudah terinstall dengan jaringan aktif, user non-root sudah dibuat, dan `sudo` sudah dikonfigurasi.

```bash
# Update sistem
sudo pacman -Syu

# Install base tools
sudo pacman -S base-devel git wget curl unzip
```

---

## 2. Driver & Display Server

### GPU — pilih sesuai hardware

```bash
# NVIDIA (sesuai env.lua)
sudo pacman -S nvidia nvidia-utils nvidia-settings libva-nvidia-driver

# AMD
sudo pacman -S mesa vulkan-radeon libva-mesa-driver

# Intel
sudo pacman -S mesa vulkan-intel intel-media-driver
```

### Wayland dependencies

```bash
sudo pacman -S wayland wayland-protocols xorg-xwayland qt5-wayland qt6-wayland
```

---

## 3. Hyprland & Ekosistem

```bash
sudo pacman -S \
    hyprland \
    hyprlock \
    hypridle \
    hyprsunset \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    polkit-kde-agent
```

### Waybar

```bash
sudo pacman -S waybar
```

### Notifikasi — Mako

```bash
sudo pacman -S mako libnotify
```

### Wallpaper — Swww

```bash
# swww tersedia di AUR (lihat bagian 6)
# binary dipanggil 'awww-daemon' di autostart.lua — pastikan swww terinstall
```

### Screenshot — Hyprshot

```bash
# Tersedia di AUR (lihat bagian 6)
sudo pacman -S grim slurp  # dependensi hyprshot
```

### Clipboard

```bash
sudo pacman -S wl-clipboard cliphist
```

---

## 4. Terminal & Shell

### Kitty

```bash
sudo pacman -S kitty
```

### Zsh & Oh My Zsh

```bash
sudo pacman -S zsh

# Set zsh sebagai default shell
chsh -s /usr/bin/zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Oh My Zsh plugins

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-completions
git clone https://github.com/zsh-users/zsh-completions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
```

### Starship prompt

```bash
sudo pacman -S starship
```

### CLI tools (dipakai di .zshrc)

```bash
sudo pacman -S eza bat zoxide fzf
```

---

## 5. Aplikasi Pendukung

### File manager — Yazi

```bash
sudo pacman -S yazi ffmpegthumbnailer unar jq poppler fd ripgrep fzf
```

### System monitor — btop

```bash
sudo pacman -S btop
```

### Font

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
# MartianMono untuk Rofi (dipakai di config.rasi dan powermenu.rasi)
# tersedia di AUR: ttf-martian-mono
```

### Icons

```bash
sudo pacman -S papirus-icon-theme
```

### Audio

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol
```

### Bluetooth

```bash
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable --now bluetooth
```

### Network

```bash
sudo pacman -S networkmanager nm-connection-editor
sudo systemctl enable --now NetworkManager
```

### Brightness

```bash
sudo pacman -S brightnessctl
```

### Media player control

```bash
sudo pacman -S playerctl
```

### Launcher — Rofi (Wayland fork)

```bash
# rofi-wayland tersedia di AUR (lihat bagian 6)
```

### Display manager (opsional)

```bash
sudo pacman -S sddm
sudo systemctl enable sddm
```

---

## 6. AUR Packages

Install AUR helper dulu jika belum ada:

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

Kemudian install semua AUR packages:

```bash
yay -S \
    rofi-wayland \
    hyprshot \
    swww \
    zen-browser-bin \
    ttf-martian-mono \
    qt6ct
```

> **zen-browser** — dipakai sebagai `$BROWSER` di binds.lua dan .zshrc.
> Bisa diganti dengan browser lain; ubah variable `browser` di `binds.lua` dan
> `export BROWSER` di `.zshrc`.

---

## 7. Deploy Config Files

Buat semua direktori config yang diperlukan:

```bash
mkdir -p \
    ~/.config/hypr/modules \
    ~/.config/waybar \
    ~/.config/rofi \
    ~/.config/kitty \
    ~/.config/mako \
    ~/.config/fastfetch \
    ~/.config/btop/themes \
    ~/.config/yazi \
    ~/.config/starship \
    ~/.config/scripts \
    ~/Pictures/Wallpapers
```

Salin semua config file ke tempatnya:

```bash
# Hyprland
cp hyprland.lua         ~/.config/hypr/
cp modules/autostart.lua  ~/.config/hypr/modules/
cp modules/binds.lua      ~/.config/hypr/modules/
cp modules/env.lua        ~/.config/hypr/modules/
cp modules/input.lua      ~/.config/hypr/modules/
cp modules/looknfeel.lua  ~/.config/hypr/modules/
cp modules/misc.lua       ~/.config/hypr/modules/
cp modules/monitors.lua   ~/.config/hypr/modules/
cp modules/windowrule.lua ~/.config/hypr/modules/
cp .luarc.json            ~/.config/hypr/

# Hypridle, Hyprlock, Hyprsunset
cp hypridle.conf  ~/.config/hypr/
cp hyprlock.conf  ~/.config/hypr/
cp hyprsunset.conf ~/.config/hypr/

# Waybar
cp waybar/config.jsonc  ~/.config/waybar/
cp waybar/style.css     ~/.config/waybar/

# Rofi
cp rofi/config.rasi     ~/.config/rofi/
cp rofi/powermenu.rasi  ~/.config/rofi/

# Kitty
cp kitty/kitty.conf  ~/.config/kitty/

# Mako
cp mako/config  ~/.config/mako/

# Fastfetch
cp fastfetch/config.jsonc  ~/.config/fastfetch/

# btop
cp btop/btop.conf     ~/.config/btop/
cp btop/custom.theme  ~/.config/btop/themes/

# Yazi
cp yazi/theme.toml  ~/.config/yazi/

# Starship
cp starship/starship.toml  ~/.config/starship/
# atau di lokasi default:
# cp starship/starship.toml ~/.config/starship.toml

# Scripts
cp scripts/powermenu.sh        ~/.config/scripts/
cp scripts/wallpaper-switcher.sh ~/.config/scripts/
chmod +x ~/.config/scripts/*.sh

# Zsh
cp zsh/.zshrc ~/.zshrc
```

---

## 8. Aktivasi Services

```bash
# Pipewire audio
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Polkit (untuk privilege dialog)
systemctl --user enable --now polkit-kde-authentication-agent-1
```

---

## 9. Pertama Kali Login

Setelah login ke Hyprland untuk pertama kali, semua program di `autostart.lua` akan
dijalankan otomatis: Waybar, Mako, Hypridle, Hyprsunset, dan daemon Swww.

Taruh setidaknya satu wallpaper di `~/Pictures/Wallpapers/`, kemudian:

```
Super + W   → pilih wallpaper via Rofi
```

### Konfigurasi monitor

Edit `~/.config/hypr/modules/monitors.lua` sesuai output monitor kamu.
Default saat ini memakai `preferred` mode dengan scale `0.75`:

```lua
hl.monitor({
    output   = "",       -- kosong = semua monitor
    mode     = "preferred",
    position = "auto",
    scale    = "0.75",   -- sesuaikan (1.0, 1.25, 1.5, dst)
})
```

Untuk melihat nama output monitor yang tersedia:
```bash
hyprctl monitors
```

---

## 10. Keybinds Referensi

| Keybind | Aksi |
|---|---|
| `Super + T` | Buka terminal (Kitty) |
| `Super + B` | Buka browser (Zen) |
| `Super + F` | File manager (Yazi di Kitty) |
| `Super + Space` | Launcher (Rofi) |
| `Super + Q` | Tutup window |
| `Super + W` | Ganti wallpaper |
| `Super + C` | Clipboard history (Rofi + cliphist) |
| `Super + S` | Screenshot (output penuh) |
| `Super + M` | Toggle scratchpad (magic) |
| `Super + P` | Pseudo tiling |
| `Super + H/J/K/L` | Fokus window (kiri/bawah/atas/kanan) |
| `Super + Shift + H/J/K/L` | Pindah window |
| `Super + Shift + T` | Toggle float window |
| `Super + Shift + F` | Maximize window |
| `Super + Shift + S` | Screenshot region |
| `Super + Shift + P` | Power menu |
| `Super + Shift + M` | Pindah window ke scratchpad |
| `Super + 1–0` | Pindah ke workspace 1–10 |
| `Super + Shift + 1–0` | Pindah window ke workspace 1–10 |
| `Super + Scroll` | Geser workspace |
| `Super + Click kiri` | Drag window |
| `Super + Click kanan` | Resize window |
| `XF86AudioRaiseVolume/LowerVolume` | Volume +/– 5% |
| `XF86AudioMute` | Mute speaker |
| `XF86AudioMicMute` | Mute mikrofon |
| `XF86MonBrightnessUp/Down` | Brightness +/– 5% |
| `XF86AudioNext/Prev/Play/Pause` | Media controls |

---

## Catatan

- Config Hyprland menggunakan **Lua API** (`hyprland.lua`), bukan format `.conf` biasa.
  Pastikan versi Hyprland yang terinstall sudah mendukung Lua config
  (tersedia sejak Hyprland v0.45+).
- `awww-daemon` di `autostart.lua` merujuk ke binary dari package **swww**.
  Jika nama binary berbeda, sesuaikan di `~/.config/hypr/modules/autostart.lua`.
- `LIBVA_DRIVER_NAME=nvidia` di `env.lua` hanya relevan untuk GPU NVIDIA.
  Hapus atau sesuaikan jika memakai AMD/Intel.
- Starship config ada di `~/.config/starship/starship.toml`. Jika tidak terbaca,
  export variabel: `export STARSHIP_CONFIG=~/.config/starship/starship.toml`
  
