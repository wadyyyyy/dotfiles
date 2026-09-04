# dotfiles

Personal macOS configuration managed with GNU Stow. The repository contains a Fish/Tide shell, terminal and multiplexer settings, window management, status bar, editor configuration, keyboard remaps, and the Homebrew dependency list.

## Included

| Directory | Purpose |
| --- | --- |
| `fish` | Fish shell, Fisher plugins, and the Tide prompt |
| `ghostty` | Ghostty terminal, font and shader settings |
| `tmux` | Vi-style tmux configuration and TPM plugins |
| `nvim` | LazyVim-based Neovim setup |
| `aerospace` | AeroSpace tiling layout and workspace rules |
| `yabai` | Window opacity via the scripting addition |
| `skhd` | Legacy hotkey configuration; not started automatically |
| `sketchybar` | Lua status bar, widgets, and AeroSpace integration |
| `borders` | Window border configuration |
| `karabiner` | Keyboard remaps and device profiles |
| `fastfetch` / `btop` | System information and resource monitor presets |
| `starship` | Optional Starship prompt configuration |
| `Brewfile` | Homebrew taps, formulae, casks, VS Code extensions, Go tools, and npm tools |
| `bootstrap.sh` | macOS defaults, dependencies, symlinks, shell setup, and services |

Each top-level directory mirrors the path that GNU Stow installs under `$HOME`:

```text
dotfiles/
├── aerospace/.config/aerospace/aerospace.toml
├── borders/.config/borders/bordersrc
├── btop/.config/btop/btop.conf
├── fastfetch/.config/fastfetch/*
├── fish/.config/fish/*
├── ghostty/.config/ghostty/*
├── karabiner/.config/karabiner/karabiner.json
├── nvim/.config/nvim/*
├── sketchybar/.config/sketchybar/*
├── skhd/.config/skhd/skhdrc
├── starship/.config/starship.toml
├── tmux/.config/tmux/*
├── yabai/.config/yabai/*
├── Brewfile
└── bootstrap.sh
```

## Quick start

```bash
git clone https://github.com/wadyyyyy/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash bootstrap.sh
```

The bootstrap script:

1. Applies the tracked macOS Finder, Dock, keyboard, trackpad, screen-lock, and software-update defaults.
2. Installs Homebrew if necessary, then runs `brew bundle --file=./Brewfile`.
3. Stows all configuration directories into `$HOME`.
4. Adds Homebrew Fish as an allowed shell, makes it the default shell, and installs the plugins listed in `fish/.config/fish/fish_plugins`.
5. Starts Yabai for window opacity, Sketchybar, and AeroSpace; disables the legacy SKHD service.

Run it from the repository root. Existing local configuration files may need to be moved out of the way before Stow can create its symlinks.

## Fish and Tide

Fish is the default shell. `fish/.config/fish/config.fish` contains aliases, abbreviations, editor variables, tool initialization, and project-specific helpers. Tide's generated functions are kept under `fish/.config/fish/functions`; the reproducible user choices live separately in `fish/.config/fish/tide.config.fish`.

The current Tide layout shows the working directory, Git state, a newline, and the command character on the left. The right side reports status, duration, context, jobs, and detected development tools.

## Window management notes

AeroSpace is the window manager and primary workspace system. It starts at login and sends workspace events to Sketchybar. Yabai is used only for window opacity through its scripting addition. SKHD is retained as a legacy hotkey configuration but is not started automatically.

Some Yabai features require partially disabling System Integrity Protection. Review the official Yabai documentation for the exact flags for the installed macOS version, then grant the required Accessibility and Screen Recording permissions to the relevant terminal and window-manager applications. The bootstrap script does not change SIP or privacy permissions.
