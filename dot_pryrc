# Note that this sets up SEPARATE files for each directory Pry is launched from!
Pry.config.history_file = ".pry_history"

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
end

Pry::Commands.block_command "pbcopy", "Copy a string to the clipboard" do |string|
  command = RUBY_PLATFORM =~ /darwin/ ? "pbcopy" : "xclip"
  IO.popen(command, "w") { |pipe| pipe.puts string }
  string
end

# Adapted from https://stackoverflow.com/a/11319086/4400644
# The "deep-inspect" Pry command is hereby available under this license:
# https://creativecommons.org/licenses/by-sa/4.0/
Pry::Commands.create_command "deep-inspect" do
  def description
    "Inspect an ActiveRecord object along with all its associations"
  end

  def process
    segments = [object.inspect]
    ActiveRecord::Base.logger.silence do
      segments += inspect_associations
    end
    output.puts segments.compact.join("\n  ")
  end

  private

  def associations
    # Omit belongs_to; we only want to go down the chain, not up.
    associations = object.class.reflect_on_all_associations(:has_one)
    associations += object.class.reflect_on_all_associations(:has_many)
    associations.compact
  end

  def inspect_associations
    associations.map { |association| inspect_association(association) }
  end

  def inspect_association(association)
    result = object.try(association.name)
    if result.is_a?(ActiveRecord::Associations::CollectionProxy)
      collection = result.to_a
      if collection.empty?
        "#{association.name}: #{collection.inspect}"
      else
        collection.inspect
      end
    else
      result.inspect
    end
  end

  def object
    @object ||= eval(args.join(" "))
  end
end

if defined?(Rails)
  my_console_methods_file = Rails.root.join('my_console_methods.rb')
  require my_console_methods_file if File.exist?(my_console_methods_file)
end
