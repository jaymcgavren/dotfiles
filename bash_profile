#Get the aliases and functions.
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
if [ -f ~/.profile ]; then
	. ~/.profile
fi

#Path setup.
export PATH=${HOME}/bin:${PATH}
export PATH=${HOME}/Shortcuts:${PATH}
export RUBYLIB=~/ruby/lib

#Command line editing options.
set -o emacs

#Create files as read-only by group, untouchable by world.
umask 027

#Only "exit" or "logout" will log off the system.
set -o ignoreeof

#Set up text editing/viewing.
export CLICOLOR=1 #Colorizes output of ls and others.
export EDITOR='/usr/bin/mate -w'
export VISUAL=$EDITOR
export PAGER=less
export LESS='-P%f (%i/%m) Line %lt/%L'

export ENV=$HOME/.bashrc

#Set up command history.
export HISTSIZE=100000
export HISTFILESIZE=100000
#Make shells write to history immediately instead of on exit.
shopt -s histappend

#Aliases.
alias add='git add'
alias am='twtr up -m'
alias clear='ruby -e "puts %Q{\n} * 80"'
alias commit='git commit'
alias jrake='jruby -S rake'
alias l='ls -alF'
alias pull='git pull'
alias push='git push'
alias serve_this_dir='python -m SimpleHTTPServer'
alias status='git status'

#The command line prompt.
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
    export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[00m\]\$ '
else
    export PS1='\u@\h:\w\n\$ '
fi

#Set starting directory.
cd ~/Projects
