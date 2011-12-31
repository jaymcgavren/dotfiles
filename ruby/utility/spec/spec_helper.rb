$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'rspec'

#Allowed margin of error for be_close.
MARGIN = 0.01

RSpec.configure do |config|
  
end
