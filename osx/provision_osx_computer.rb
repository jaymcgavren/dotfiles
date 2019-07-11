#!/usr/bin/env ruby

require "fileutils"

def parse_package_list(string)
  lines = string.split("\n")
  active_packages = lines.reject{|package| package =~ /\A\s*\#/}
  active_packages.each { |package| package.sub!(/\s*\#.*\Z/, '') }
  active_packages
end

brew_packages = parse_package_list(<<-EOD)
ack
aspell
atk
autoconf
automake
bash-git-prompt
bash-completion
bats
binutils
brew-cask
brogue
cabextract
cliclick # Script mouse clicks
cmake
cmatrix
composer
coreutils
cowsay
ctags
curl
diffutils
dos2unix
ed
emacs
faac
fceux
ffmpeg
findutils
flac
fontconfig
fortune
freetype
gawk
gdbm
gdk-pixbuf
gettext
gfortran
gifsicle
gist
git
git-extras
git-flow
glib
gmp
gnu-indent
gnu-sed
gnu-tar
gnu-which
gnutls
go
grep
gtk+
gzip
harfbuzz
icu4c
imagemagick
jasper
jpeg
lame
less
libao
libdvdcss
libevent
libffi
libgpg-error
libicns
libksba
libogg
libpng
libsndfile
libtasn1
libtiff
libtool
libvorbis
libyaml
libzip
lua
lynx
lzip
mad
markdown
mcrypt
memcached
mg
mhash
mysql
namebench
netcat
nettle
node
nodenv
open-tyrian # Shoot-em-up game
openssh --with-brewed-openssl
openssl
ossp-uuid
p11-kit
pango
pcre
phantomjs
php55
php55-mcrypt
pidof
pixman
pkg-config
postgresql
pstree
python --with-brewed-openssl
r
readline
reattach-to-user-namespace
redis
rename
rsync
s3fs
scons
screen
sdl # For game development
sdl2 # For game development
sdl2_image # For game development
sdl2_ttf # For game development
sdl2_mixer # For game development
sox
sqlite
subversion
supertux --devel
svn
terminal-notifier # Alerts to OSX Notification Center via terminal.
the_silver_searcher
tmux
todo-txt
tree
ttyrec
unixodbc
unrar
unzip
vim
watch
wdiff --with-gettext
wget
wine
winetricks
x264
xvid
xz
yasm
zlib
zsh
EOD

cask_packages = parse_package_list(<<-EOD)
amazon-music
anki
bettertouchtool
celestia
desmume # Nintendo DS emulator
docker
dolphin # Nintendo GameCube/Wii emulator
dosbox
dropbox
# dwarf-fortress
electric-sheep
emacs
firefox
# freeciv
gimp
gitx
google-chrome
gridwars
handbrake
hedgewars
hipchat
iterm2
java
jumpcut
kid3
libreoffice
mame
menumeters # No recipe available.
minecraft
nethackcocoa
noiz2sa
omnidazzle
openemu # Multi-console emulator, including NES, SNES, Genesis, etc.
picasa
# postgres
# prezi
processing
rescuetime
rrootage
# sauerbraten
screenflow
screenhero
scummvm
sequel-pro
shoes
sketchup
skype
slate
# soundflower
steam
stella
sublime-text
teeworlds
# torbrowser
# tower
# transmit
unity-web-player
vagrant
virtualbox
vlc
wesnoth
wireshark
xaos
xscreensaver
EOD

def run(command)
  puts `#{command} 2>&1`
end

# Link dotfiles to paths where they'll actually be accessed.
run "ln -s ~/dotfiles/gitconfig ~/.gitconfig"
run "ln -s ~/dotfiles/gitignore ~/.gitignore"
run "ln -s ~/dotfiles/inputrc ~/.inputrc"
run "ln -s ~/dotfiles/irbrc ~/.irbrc"
run "ln -s ~/dotfiles/rp5rc ~/.rp5rc"
run "ln -s ~/dotfiles/slate ~/.slate"
run "ln -s ~/dotfiles/tmux.conf ~/.tmux.conf"

# Set up Cask.
run "brew install caskroom/cask/brew-cask"

# Set up required libraries.
run "brew link pcre"
run "brew cask install xquartz"

# Install configured packages.
brew_packages.each do |package|
  run "brew install #{package}"
end
cask_packages.each do |package|
  run "brew cask install #{package}"
end

# Clean up Homebrew cache.
run "brew cleanup"
run "brew cask cleanup"

# Eliminate useless fading animation on iTerm2 hotkey window.
run "defaults write com.googlecode.iterm2 HotkeyTermAnimationDuration -float 0.00001"

# Disable Mission Control/Expose.
run "defaults write com.apple.dock mcx-expose-disabled -bool TRUE && killall Dock"
