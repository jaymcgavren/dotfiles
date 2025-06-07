eval "$(/opt/homebrew/bin/brew shellenv)"

source $HOME/dotfiles/aliases

# Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/zprofile ]; then
  . $HOME/dotfiles_local/zprofile
fi
