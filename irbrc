require 'rubygems'

require 'irb/completion'
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 50000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

require 'hirb'
extend Hirb::Console
Hirb::View.enable
