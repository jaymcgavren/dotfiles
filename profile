#Path setup.
export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/sbin
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=${PATH}:/usr/local/mysql/bin
export PATH=${PATH}:/usr/local/Cellar/python
export PATH=${PATH}:${HOME}/Applications/jruby-1.6.4/bin
export PATH=${HOME}/Shortcuts:${PATH}
export PATH=${HOME}/dotfiles/bin:${PATH}
export PATH=$PATH:${HOME}/Applications/android-sdk/tools/
if [[ $OSTYPE == *darwin* ]]; then
  export PATH=${HOME}/dotfiles/bin/osx:${PATH}
elif [[ $OSTYPE == *linux* ]]; then
  export PATH=${HOME}/dotfiles/bin/linux:${PATH}
fi
export PATH=${HOME}/dotfiles_local/bin:${PATH}

export RUBYLIB=${HOME}/ruby/lib:${RUBYLIB}
export RUBYLIB=${HOME}/dotfiles/ruby/lib:${RUBYLIB}
export RUBYLIB=lib:${RUBYLIB}

export GLASSFISH_HOME=${HOME}/Applications/glassfishv3
export IVY_HOME=${HOME}/ivy-cache
export ANT_HOME=${HOME}/Applications/ant
export M2_HOME=${HOME}/Applications/apache-maven-2.2.1
export M2=$M2_HOME/bin
export PATH=${M2}:${PATH}

#Create files as read-only by group, untouchable by world.
umask 027

#Keep this last so it can override general settings!
if [ -f $HOME/dotfiles_local/profile ]; then
  . $HOME/dotfiles_local/profile
fi
