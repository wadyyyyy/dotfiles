# dotfiles

Personal macOS dotfiles: shell, terminal, WM, status bar, editor, brew casks and CLI tooling.

## What's included

- `yabai` — tiling window manager (`skhd` for hotkeys).
- `sketchybar` — Lua-based status bar with widgets and AeroSpace integration.
- `ghostty` — terminal config.
- `fish` — main shell config.
- `starship` — minimal prompt configuration.
- `tmux` — vi-style tmux setup with resize/swap bindings and plugins.
- `nvim` — LazyVim-based Neovim config.
- `karabiner` — keyboard remaps.
- `fastfetch` — preset (`apple.jsonc`).
- `OBS` settings
- `Brewfile` — brew dump.
- `bootstrap.sh` — proceed installation

## Repository layout

Each top-level folder mirrors the corresponding `~/.config/...` path:

```text
dotfiles/
├── yabai/.config/yabai/yabairc
├── skhd/.config/skhd/skhdrc
├── aerospace/.config/aerospace/aerospace.toml (unused)
├── fastfetch/.config/fastfetch/*
├── fish/.config/fish/config.fish
├── ghostty/.config/ghostty/*
├── karabiner/.config/karabiner/karabiner.json
├── nvim/.config/nvim/*
├── sketchybar/.config/sketchybar/*
├── starship/.config/starship.toml
├── tmux/.config/tmux/tmux.conf
├── bootstrap.sh
└── Brewfile
```

## Requirements & macOS Setup

For the full feature set of `yabai` (including the Scripting Addition), you need to partially disable **SIP (System Integrity Protection)**.

1. Shut down your Mac.
2. Press and hold the power button until you see **"Loading startup options"**.
3. Click **Options**, then click **Continue**.
4. Open **Terminal** from the Utilities menu in the menu bar.
5. Run the appropriate command for your system and OS version:

```text
# APPLE SILICON

# If you're on Apple Silicon macOS 13.x.x OR newer
# Requires Filesystem Protections, Debugging Restrictions and NVRAM Protection to be disabled
# (printed warning can be safely ignored)
csrutil enable --without fs --without debug --without nvram

# If you're on Apple Silicon macOS 12.x.x
# Requires Filesystem Protections, Debugging Restrictions and NVRAM Protection to be disabled
# (printed warning can be safely ignored)
csrutil disable --with kext --with dtrace --with basesystem

# INTEL

# If you're on Intel macOS 11.x.x OR newer
# Requires Filesystem Protections and Debugging Restrictions to be disabled (workaround because --without debug does not work)
# (printed warning can be safely ignored)
csrutil disable --with kext --with dtrace --with nvram --with basesystem
```

Reboot your Mac.

```
1. For Apple Silicon: Enable non-Apple-signed arm64e binaries by opening a terminal and running the below command, then rebooting again: sudo nvram boot-args=-arm64e_preview_abi
2. Grant the necessary Accessibility and Screen Recording permissions to your terminal/yabai in System Settings.
```

## Quick start

```bash
git clone https://github.com/wadyyyyy/dotfiles.git ~/dotfiles
cd ~/dotfiles/
bash bootstrap.sh
```
