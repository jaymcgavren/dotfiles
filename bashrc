# https://unix.stackexchange.com/questions/43601/how-can-i-set-my-default-shell-to-start-up-tmux
if command -v tmux>/dev/null; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && tmux
fi

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/bashrc ]; then
    . $HOME/dotfiles_local/bashrc
fi
