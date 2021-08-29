if [ -f $HOME/.profile ]; then
    . $HOME/.profile
fi

if [ -f $HOME/.bashrc ]; then
    . $HOME/.bashrc
fi

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

export MANPATH=/opt/local/share/man:$MANPATH

#Command line editing options.
set -o emacs

#Only "exit" or "logout" will log off the system.
set -o ignoreeof

#stty binds kill = ^U and werase = ^W by default.
#This will allow setting these keys in ~/.inputrc instead.
stty werase undef
stty kill undef

#Set up text editing/viewing.
export LANG=en_US.utf-8
export CLICOLOR=1 #Colorizes output of ls and others.
export EDITOR=mg
export VISUAL=$EDITOR
export PAGER=less
export LESS='-R-i-P%f (%i/%m) Line %lt/%L' #ANSI color, better prompt, case-insensitive search.
export LS_COLORS=$LS_COLORS:'di=1;44:'

export ENV=$HOME/.bashrc

#Set up command history.
export HISTSIZE=100000
export HISTFILESIZE=100000
#Leave commands that start with space out of history.
export HISTCONTROL=ignorespace
#Make shells write to history immediately instead of on exit.
shopt -s histappend
export PROMPT_COMMAND='history -a'

#Aliases.
alias alert='terminal-notifier'
alias be='bundle exec'
alias bi='bundle install --quiet'
alias clear='ruby -e "puts %Q{\n} * 80"'
alias db=sequel_pro
alias find_source='find . -type f -not -path "*/target/*" -not -path "*/.svn/*" -not -path "*/.git/*" -not -name ".DS_Store" -not -iname "*.jar" -not -iname "*.gif" -not -iname "*.jpg" -not -iname "*.png"'
alias jrake='jruby -S rake'
alias ls='ls --color=auto'
alias l='ls -alF'
alias latest_download='latest ~/Downloads'
alias latest_screenshot='latest ~/Pictures/Screenshots'
alias please=sudo
alias s=search
alias serve_this_dir='python -m SimpleHTTPServer'
alias tree="tree -I 'node_modules|tmp'"

#Functions.
function gitrm {
    git status | grep 'deleted' | awk '{print $3}' | xargs git rm
}
function latest {
  ls -t $1/* | head -n 1
}
function toss {
    for filename; do
        if [ -e $HOME/.Trash/$filename ]; then
            mv "${filename}" "${HOME}/.Trash/${filename}$(date +%Y%m%d%H%M%S)"
        else
            mv "${filename}" "${HOME}/.Trash"
        fi
    done
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
function my_ip {
    ifconfig | grep 'broadcast' | awk '{print $6}'
}
function variables() {
  comm -23 <(declare) <(declare -f) ;
}

#The command line prompt.
case "$TERM" in
    xterm) color_prompt=yes;;
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    screen-256color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
    # export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[00m\]\$ ' #No date
    export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \[\033[00m\]\$ "
else
    # export PS1='\u@\h:\w\n\$ ' #No date
    export PS1="[\$(date +%Y%m%d_%H%M%S)] \u@\h:\w\n\$ "
fi

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/bash_profile ]; then
    . $HOME/dotfiles_local/bash_profile
fi
