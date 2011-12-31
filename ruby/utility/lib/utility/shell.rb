#Require this file when running irb for some useful extensions.

require 'utility/all'

require 'rubygems'
require 'rush'

LOCALHOST = Rush::Box.new('localhost')
HOME = LOCALHOST["#{ENV['HOME']}/"]
DOWNLOADS = HOME['Downloads/']
DOCUMENTS = HOME['Documents/']
PROJECTS = HOME['Projects/']
