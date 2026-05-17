if ENV['RAILS_ENV']
  load File.join(File.dirname(__FILE__), '.railsrc')
end

%w{irb/completion}.each do |lib|
  begin
    require lib
  rescue LoadError => err
    $stderr.puts "Couldn't load #{lib}: #{err}"
  end
end

# Setup permanent history.
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

# Disable annoying Reline autocomplete.
IRB.conf[:USE_AUTOCOMPLETE] = false

def history
  puts Readline::HISTORY.entries.last(50).join("\n")
end

def pbcopy(string)
  command = RUBY_PLATFORM =~ /darwin/ ? "pbcopy" : "xclip"
  IO.popen(command, "w") { |pipe| pipe.puts string }
  string
end

class Object
  def interesting_methods
    case self.class
    when Class
      self.public_methods.sort - Object.public_methods
    when Module
      self.public_methods.sort - Module.public_methods
    else
      self.public_methods.sort - Object.new.public_methods
    end
  end
end
