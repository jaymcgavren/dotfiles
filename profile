#Go language setup.
export GOPATH=${HOME}/go

#nodenv setup.
if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi

#Path setup.
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/sbin
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=${PATH}:/usr/local/mysql/bin
export PATH=${PATH}:/usr/local/Cellar/python
export PATH=${PATH}:/usr/local/share/npm/bin
export PATH=${PATH}:${HOME}/Applications/jruby-1.6.4/bin
export PATH=${HOME}/Shortcuts:${PATH}
export PATH=${HOME}/dotfiles/bin:${PATH}
export PATH=$PATH:${HOME}/Applications/android-sdk/tools
export PATH=${PATH}:${GOPATH}/bin
# Replace OSX core utilities with GNU versions.
if [[ $OSTYPE == *darwin* ]]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi
if [[ $OSTYPE == *darwin* ]]; then
  export PATH=${HOME}/dotfiles/bin/osx:${PATH}
  export PATH=${HOME}/dotfiles_local/bin/osx:${PATH}
  export PATH=$PATH:/Applications/dart/dart-sdk/bin
elif [[ $OSTYPE == *linux* ]]; then
  export PATH=${HOME}/dotfiles/bin/linux:${PATH}
  export PATH=${HOME}/dotfiles_local/bin/linux:${PATH}
fi
export PATH=${HOME}/dotfiles_local/bin:${PATH}

# if [[ $OSTYPE == *darwin* ]]; then
#   export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
# fi


export RUBYLIB=${HOME}/ruby/lib:${RUBYLIB}
export RUBYLIB=${HOME}/dotfiles/ruby/lib:${RUBYLIB}

#Create files as read-only by group and world.
umask 022

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/profile ]; then
  . $HOME/dotfiles_local/profile
fi
