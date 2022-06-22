eval "$(/opt/homebrew/bin/brew shellenv)"

# rbenv (Ruby environment) setup.
eval "$(rbenv init - --no-rehash)"
export PATH="$HOME/.rbenv/bin:$PATH"

# nvm (Node version manager) setup.
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

# nodenv setup.
if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

#Path setup.
export PATH=${HOME}/dotfiles/bin:${PATH}
export PATH="/usr/local/opt/postgresql@12/bin:$PATH"

source `brew --prefix`/share/gem_home/gem_home.sh

# Replace OSX core utilities with GNU versions.
if [[ $OSTYPE == *darwin* ]]; then
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
  export PATH="$(brew --prefix ed)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gnu-indent)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gnu-tar)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gnu-which)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gnutls)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix grep)/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix gnu-indent)/libexec/gnubin:$PATH"
fi
if [[ $OSTYPE == *darwin* ]]; then
  export PATH=${HOME}/dotfiles/bin/osx:${PATH}
  export PATH=${HOME}/dotfiles_local/bin/osx:${PATH}
elif [[ $OSTYPE == *linux* ]]; then
  export PATH=${HOME}/dotfiles/bin/linux:${PATH}
  export PATH=${HOME}/dotfiles_local/bin/linux:${PATH}
fi
export PATH=${HOME}/dotfiles_local/bin:${PATH}
export PATH=${PATH}:${HOME}/go/bin

#Create files as read-only by group and world.
umask 022

setopt interactivecomments

# History setup.
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/zshrc ]; then
  . $HOME/dotfiles_local/zshrc
fi
