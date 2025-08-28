#!/bin/sh

dotfiles_path=~/dotfiles

# Link dotfiles to paths where they'll actually be accessed.
ln -s ${dotfiles_path}/agignore ~/.agignore
ln -s ${dotfiles_path}/gitconfig ~/.gitconfig
ln -s ${dotfiles_path}/gitignore ~/.gitignore
ln -s ${dotfiles_path}/inputrc ~/.inputrc
ln -s ${dotfiles_path}/irbrc ~/.irbrc
ln -s ${dotfiles_path}/pryrc ~/.pryrc
ln -s ${dotfiles_path}/rp5rc ~/.rp5rc
ln -s ${dotfiles_path}/slate ~/.slate
ln -s ${dotfiles_path}/tmux.conf ~/.tmux.conf
ln -s ${dotfiles_path}/zprofile ~/.zprofile
ln -s ${dotfiles_path}/zshrc ~/.zshrc
ln -s ${dotfiles_path}/todo-txt-sh/todo.cfg ~/.todo.cfg
mkdir ~/.config
ln -s ${dotfiles_path}/.config/karabiner ~/.config/karabiner
