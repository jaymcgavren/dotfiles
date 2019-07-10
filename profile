#nodenv setup.
if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi

#Path setup.
export PATH=/usr/local/sbin:$PATH
export PATH=${HOME}/dotfiles/bin:${PATH}

# Replace OSX core utilities with GNU versions.
if [[ $OSTYPE == *darwin* ]]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
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

# if [[ $OSTYPE == *darwin* ]]; then
#   export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem
# fi

#Create files as read-only by group and world.
umask 022

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/profile ]; then
  . $HOME/dotfiles_local/profile
fi
