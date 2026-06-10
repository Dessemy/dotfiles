> Personal Hyprland

---

## 1. Prerequisites

### Install Base Tools

Grab `git`, `base-devel`, and the AUR helper `yay`:

```bash
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
```

---

## what gets installed

### Core components
- **awww**
- **hyprlock**
- **hypridle**
- **hyprsunset**
- **hyprpicker**
- **waybar**
- **rofi-wayland**
- **rofi-calc**
- **mako**
- **tuigreet**
- **pavucontrol**
- **blueman**
- **zsh**
- **starship**
- **tmux**
- **zoxide**
- **ttf-jetbrains-mono-nerd**
- **noto-fonts-cjk**
- **noto-fonts-emoj**
- **neovim**
- **bat**
- **btop**
- **brightnessctl**
- **cliphist**
- **eza**
- **fd**
- **fzf**
- **imv**
- **jq**
- **nwg-look**
- **ripgrep**
- **wl-clipboard**
- **mpv**
- **ffmpegthumbnailer

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

> **Warning:** This will wipe your entire `~/.config` directory. Back it up first if you need anything from there.

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

## 5. Configure Greetd

Edit `/etc/greetd/config.toml`:

```bash
sudo nvim /etc/greetd/config.toml
```

Add the following:

```toml
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --remember-session --sessions /usr/share/wayland-sessions --theme 'border=cyan;text=#cacccc;prompt=#cacccc;time=#cacccc;action=cyan;button=cyan;container=#101315;input=white'"
user = "greeter"
```

### Reboot

```bash
reboot
```

---

## 6. Notes
