#!/usr/bin/env ruby

def parse_package_list(string)
  string.split("\n").reject{|package| package =~ /\A\s*\#/}
end

brew_packages = parse_package_list(<<-EOD)
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
sdl
sox
sqlite
subversion
svn
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
google-chrome
firefox
java
adobe-reader
amazon-music
anki
audacity
bettertouchtool
celestia
desmume
dosbox
dropbox
# dwarf-fortress
electric-sheep
emacs
# freeciv
gimp
gitx
google-drive
google-earth
gridwars
handbrake
handbrakecli
hedgewars
hipchat
horndis
jumpcut
kid3
libreoffice
onepassword
vagrant
mame
menumeters # No recipe available.
minecraft
nethackcocoa
node
noiz2sa
omnidazzle
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
snes9x
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
xaos
xbox360-controller-driver
xscreensaver
EOD

def run(command)
  puts `#{command} 2>&1`
end

# Add additional Homebrew sources.
run "brew tap homebrew/dupes"

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
run "brew cask cleanup'

# Configuration
run "git config --global color.ui true"
