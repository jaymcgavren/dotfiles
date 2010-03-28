#Get aliases and functions.
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
if [ -f ~/.profile ]; then
    . ~/.profile
fi
if [ -f ~/dotfiles/host_specific/$HOSTNAME/bash_profile ]; then
    . ~/dotfiles/host_specific/$HOSTNAME/bash_profile
fi

#Path setup.
export PATH=${HOME}/bin:${PATH}
export PATH=${HOME}/dotfiles/bin:${PATH}
if [[ $OSTYPE == *darwin* ]]; then
    export PATH=${HOME}/dotfiles/bin/osx:${PATH}
fi
export RUBYLIB=${HOME}/ruby/lib:${RUBYLIB}
export RUBYLIB=${HOME}/dotfiles/ruby/lib:${RUBYLIB}
export RUBYLIB=lib:${RUBYLIB}
export PATH=${HOME}/Shortcuts:${PATH}

#Command line editing options.
set -o emacs

#Create files as read-only by group, untouchable by world.
umask 027

#Only "exit" or "logout" will log off the system.
set -o ignoreeof

#Set up text editing/viewing.
export CLICOLOR=1 #Colorizes output of ls and others.
export EDITOR=vi
export VISUAL=$EDITOR
export PAGER=less
export LESS='-i-P%f (%i/%m) Line %lt/%L' #Better prompt, case-insensitive search by default.

export ENV=$HOME/.bashrc

#Set up command history.
export HISTSIZE=100000
export HISTFILESIZE=100000
#Make shells write to history immediately instead of on exit.
shopt -s histappend

#Aliases.
alias alert='growlnotify -s'
alias am='twtr up -m'
alias clear='ruby -e "puts %Q{\n} * 80"'
alias jrake='jruby -S rake'
alias l='ls -alF'
alias player='/Applications/VLC.app/Contents/MacOS/VLC'
alias serve_this_dir='python -m SimpleHTTPServer'


#Functions.
function gitrm {
    git status | grep 'deleted' | awk '{print $3}' | xargs git rm
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
function my_ip {
    ifconfig | grep 'broadcast' | awk '{print $6}'
}

#The command line prompt.
case "$TERM" in
    xterm) color_prompt=yes;;
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
    export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[00m\]\$ '
else
    export PS1='\u@\h:\w\n\$ '
fi

#Set starting directory.
cd ~/Projects
