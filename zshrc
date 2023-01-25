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

umask 022 #Create files as read-only by group and world.

setopt INTERACTIVE_COMMENTS # Allow # following typed commands.
setopt NO_CLOBBER # Prevent > from overwriting existing files.

# History setup.
setopt HIST_IGNORE_SPACE # Don't save commands that begin with a space character.
setopt EXTENDED_HISTORY # Save timestamps with each command.
setopt SHARE_HISTORY # Multiple zsh instances will sync their histories.
export HISTFILE=$HOME/.zsh_history # File to save/load history to/from.
export HISTSIZE=100000 # Number of commands to track.
export SAVEHIST=$HISTSIZE # Number of commands to save

#Set up text editing/viewing.
export LANG=en_US.utf-8
export CLICOLOR=1 #Colorizes output of ls and others.
export EDITOR=mg
export VISUAL=$EDITOR
export PAGER=less
export LESS='-R-i-P%f (%i/%m) Line %lt/%L' #ANSI color, better prompt, case-insensitive search.
export LS_COLORS=$LS_COLORS:'di=1;44:'

function git_recent()
{
  git checkout $(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' --color | head -n 8 | fzf --height 20%)
}

function mkcd {
    if [ ! -n "$1" ]; then
        echo "Enter a directory name"
    elif [ -d $1 ]; then
        echo "\`$1' already exists"
    else
        mkdir $1 && cd $1
    fi
}

function toss {
  for filename; do
    if [ -e $HOME/.Trash/$filename ]; then
      mv "${filename}" "${HOME}/.Trash/${filename}$(date +%Y%m%d%H%M%S)"
    else
      mv "${filename}" "${HOME}/.Trash/${filename}"
    fi
  done
}

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/zshrc ]; then
  . $HOME/dotfiles_local/zshrc
fi
