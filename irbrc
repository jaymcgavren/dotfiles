%w{rubygems wirble hirb irb/completion irb/ext/save-history}.each do |lib|
  begin
    require lib
  rescue LoadError => err
    $stderr.puts "Couldn't load #{lib}: #{err}"
  end
end

ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

IRB.conf[:SAVE_HISTORY] = 50000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
def history; puts Readline::HISTORY.entries.last(50).join("\n"); end

Wirble.init
Wirble.colorize

extend Hirb::Console
Hirb::View.enable
