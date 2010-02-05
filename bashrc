if [ -f ~/dotfiles/host_specific/$HOSTNAME/bashrc ]; then
    . ~/dotfiles/host_specific/$HOSTNAME/bashrc
fi

export PATH=${PATH}:/usr/local/mysql/bin
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=$PATH:/opt/jruby/bin

export MANPATH=/opt/local/share/man:$MANPATH
