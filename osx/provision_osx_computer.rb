#!/usr/bin/env ruby

require "fileutils"

def run(command)
  puts `#{command} 2>&1`
end

run "brew bundle --file ~/dotfiles/Brewfile"

# Clean up Homebrew cache.
run "brew cleanup"

# Eliminate useless fading animation on iTerm2 hotkey window.
run "defaults write com.googlecode.iterm2 HotkeyTermAnimationDuration -float 0.00001"

# Disable Mission Control/Expose.
run "defaults write com.apple.dock mcx-expose-disabled -bool TRUE && killall Dock"
