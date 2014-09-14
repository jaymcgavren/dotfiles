#!/usr/bin/env ruby

def parse_package_list(string)
  string.split("\n").reject{|package| package =~ /\A\s*\#/}
end

packages = parse_package_list(<<-EOD)
7zip
7zip.commandline
ack
adobereader
# android-sdk
Atom
audacity
autohotkey.portable
cdburnerxp
ChocolateyGUI
Console2
curl
cyg-get
Cygwin
dolphin
DotNet4.5
dropbox
Emacs
evernote
ffmpeg
filezilla
Firefox
gimp
git
GoogleChrome
# googledrive
googleearth
Growl
hedgewars
imagemagick
imagemagick.app
InkScape -Version 0.48.5
IrfanView
iTunes
kdiff3
libreoffice
# mirc
nodejs
nodejs.commandline
notepadplusplus
paint.net
picasa
pip
procexp
putty
python
Quicktime
R.Project
ruby
sauerbraten
secret-maryo-chronicles
SQLite
# steam
StrawberryPerl
SublimeText3
SublimeText3.PackageControl
supertuxkart
svn
sysinternals
# tightvnc
TortoiseGit
unitywebplayer
vcredist2010
virtualbox
vlc
wesnoth
Wget
windirstat
winrar
winscp
wireshark
xonotic
youtube-dl
EOD

def run(command)
  puts `#{command} 2>&1`
end

run %q{@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin}

# Install configured packages.
packages.each do |package|
  run "choco install #{package}"
end
