# Note that this sets up SEPARATE files for each directory Pry is launched from!
Pry.config.history_file = ".pry_history"

Pry::Commands.block_command "pbcopy", "Copy a string to the clipboard" do |string|
  command = RUBY_PLATFORM =~ /darwin/ ? "pbcopy" : "xclip"
  IO.popen(command, "w") { |pipe| pipe.puts string }
  string
end
