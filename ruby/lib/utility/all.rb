require 'rubygems'
require 'utility/main'
require 'utility/email'
require 'utility/enhancements'
require 'utility/filter'
require 'utility/logging'
require 'utility/storage'

include Utility

module Utility
  include Logging
  include Storage
  include Main
  include Email
end

class Util
  include Utility
end