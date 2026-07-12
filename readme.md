# dotfiles

Personal macOS dotfiles: shell, terminal, WM, status bar, editor, brew casks and CLI tooling.

## What's included

- `aerospace` — tiling window manager config ([AeroSpace](https://github.com/nikitabobko/AeroSpace)).
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
├── aerospace/.config/aerospace/aerospace.toml
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

## Quick start

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles/
bash bootstrap.sh
```
