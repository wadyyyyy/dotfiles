#!/bin/bash

echo "setting macos defaults..."

defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

defaults write com.apple.dock mru-spaces -bool false

defaults write NSGlobalDomain _HIHideMenuBar -bool true

# defaults write NSGlobalDomain KeyRepeat -int 1
# defaults write NSGlobalDomain InitialKeyRepeat -int 5

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write com.apple.HIToolbox AppleFnUsageType -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -int 1
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false

sudo pmset -a lowpowermode 0
sudo pmset -a displaysleep 10

killall Dock
killall Finder
killall SystemUIServer

mkdir -p ~/.config

echo "~~~ setting up homebrew..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "~~~homebrew is already installed"
fi

echo "~~~ downloading dependencies, utils and casks from brewfile..."
if [ -f "./Brewfile" ]; then
    brew bundle --file=./Brewfile
else
    echo "~~~ brewfile not found! installing stow and fish..."
    brew install stow fish
fi

echo "~~~ adding symlinks with gnu stow..."
stow -v */

FISH_PATH="/opt/homebrew/bin/fish"

if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "~~~ adding fish to /etc/shells (requires sudo)..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$FISH_PATH" ]; then
    echo "~~~ setting fish as default shell..."
    chsh -s "$FISH_PATH"
else
    echo "~~~ fish is already default shell."
fi

yabai --start-service
skhd --start-service

echo "~~~ all done! reboot system"
