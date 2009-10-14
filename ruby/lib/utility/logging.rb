require 'logger'
require 'utility/storage'


module Utility


module Logging

  class Config
    include Storage
  end
  
  begin
    config = Config.new
    HANDLE = open(config.load(:logging_file), 'a')
    LEVEL = config.load(:logging_level)
  rescue Exception => exception
    warn exception
    HANDLE = STDOUT
    LEVEL = Logger::INFO
  end

  Logs = {}
  #Returns a logger for the current object, creating a new one if necessary.
  def log
    unless Logs[object_id]
      Logs[object_id] = Logger.new(HANDLE)
      Logs[object_id].level = LEVEL
      Logs[object_id].progname = self
    end
    Logs[object_id]
  end
  
end


end #module Utility
