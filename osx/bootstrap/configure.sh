#!/bin/sh

# Close System Preferences to prevent overriding changes.
osascript -e 'tell application "System Preferences" to quit'

# Show all file extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show hidden files in Finder.
defaults write com.apple.finder AppleShowAllFiles true
killall Finder

# Save screenshots to the Downloads folder.
defaults write com.apple.screencapture location ~/Downloads

