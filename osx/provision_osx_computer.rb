#!/usr/bin/env ruby

require "fileutils"

def run(command)
  puts `#{command} 2>&1`
end

# Link dotfiles to paths where they'll actually be accessed.
run "ln -s ~/dotfiles/gitconfig ~/.gitconfig"
run "ln -s ~/dotfiles/gitignore ~/.gitignore"
run "ln -s ~/dotfiles/inputrc ~/.inputrc"
run "ln -s ~/dotfiles/irbrc ~/.irbrc"
run "ln -s ~/dotfiles/rp5rc ~/.rp5rc"
run "ln -s ~/dotfiles/slate ~/.slate"
run "ln -s ~/dotfiles/tmux.conf ~/.tmux.conf"

run "brew bundle --file ~/dotfiles/Brewfile"

# Clean up Homebrew cache.
run "brew cleanup"

# Eliminate useless fading animation on iTerm2 hotkey window.
run "defaults write com.googlecode.iterm2 HotkeyTermAnimationDuration -float 0.00001"

# Disable Mission Control/Expose.
run "defaults write com.apple.dock mcx-expose-disabled -bool TRUE && killall Dock"
