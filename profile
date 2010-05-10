#Path setup.
export PATH=/usr/local/bin:$PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=${PATH}:/usr/local/mysql/bin
export PATH=$PATH:/opt/jruby/bin
export PATH=${HOME}/bin:${PATH}
export PATH=${HOME}/dotfiles/bin:${PATH}
export PATH=${HOME}/Shortcuts:${PATH}
if [[ $OSTYPE == *darwin* ]]; then
    export PATH=${HOME}/dotfiles/bin/osx:${PATH}
fi

export RUBYLIB=${HOME}/ruby/lib:${RUBYLIB}
export RUBYLIB=${HOME}/dotfiles/ruby/lib:${RUBYLIB}
export RUBYLIB=lib:${RUBYLIB}

#Create files as read-only by group, untouchable by world.
umask 027

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/profile ]; then
    . $HOME/dotfiles_local/profile
fi
