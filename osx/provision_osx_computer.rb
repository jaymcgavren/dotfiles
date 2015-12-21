#!/usr/bin/env ruby

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
bash-completion
bats
binutils
brew-cask
cabextract
cmake
cmatrix
composer
coreutils --default-names
cowsay
ctags
curl
diffutils
docker
dos2unix
ed --default-names
emacs
faac
fasd
fceux
ffmpeg
findutils --default-names
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
gnu-indent --default-names
gnu-sed --default-names
gnu-tar --default-names
gnu-which --default-names
gnutls --default-names
go
grep --default-names
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
mhash
mysql
namebench
netcat
nettle
node
nodenv
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
adobe-reader
amazon-music
anki
audacity
bettertouchtool
celestia
desmume # Nintendo DS emulator
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
google-drive
google-earth
gridwars
handbrake
handbrakecli
hedgewars
hipchat
horndis
# iterm2
java
jumpcut
kid3
libreoffice
mame
menumeters # No recipe available.
minecraft
nethackcocoa
node
noiz2sa
omnidazzle
onepassword
openemu # Multi-console emulator, including NES, SNES, Genesis, etc.
phantomjs
picasa
# postgres
# prezi
processing
r
rescuetime
rrootage
# sauerbraten
screenflow
screenhero
scummvm
sequel-pro
sketchup
skype
slate
# soundflower
sqlite-database-browser
steam
stella
sublime-text
teeworlds
# torbrowser
totalterminal
# tower
# transmit
unity-web-player
unity3d
vagrant
virtualbox
vlc
wesnoth
wireshark
wjoy # Wii controller driver.
xaos
xbox360-controller-driver
xscreensaver
EOD

def run(command)
  puts `#{command} 2>&1`
end

# Add additional Homebrew sources.
run "brew tap homebrew/dupes"
run "brew tap homebrew/games"

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

# Link .app files to /Applications.
run "brew linkapps"

# Clean up Homebrew cache.
run "brew cleanup"
run "brew prune"
run "brew cask cleanup"

# Link dotfiles to paths where they'll actually be accessed.
run "ln -s ~/dotfiles/gitconfig ~/.gitconfig"
run "ln -s ~/dotfiles/gitignore ~/.gitignore"
run "ln -s ~/dotfiles/inputrc ~/.inputrc"
run "ln -s ~/dotfiles/irbrc ~/.irbrc"
run "ln -s ~/dotfiles/rp5rc ~/.rp5rc"
run "ln -s ~/dotfiles/slate ~/.slate"
run "ln -s ~/dotfiles/tmux.conf ~/.tmux.conf"

# Set up go language.
mkdir ~/go
