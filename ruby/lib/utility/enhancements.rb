require 'rubygems'


#Delays loading ActiveSupport/Extlib methods until they are called.
module DeferredExtensions
  def method_missing(method, *arguments, &block)
    require 'activesupport'
    require 'extlib'
    if self.respond_to?(method)
      self.send(method, *arguments, &block)
    else
      raise NoMethodError.new("#{method} not defined")
    end
  end
end


class Object

  #Call <<() on target with self.
  #Allows statements like 'foo'.append(file) instead of file << 'foo'.
  def append_to(target)
    target << self
  end
  
  #Format an object as YAML.
  def serialize
    require 'yaml'
    YAML.dump(self)
  end
  
end


class Hash

  include DeferredExtensions
  
  #Format a hash into 'key: value' lines.
  def to_s
    strings = []
    self.each {|k, v| strings << "#{k}: #{v}"}
    strings.join("\n")
  end
  
end


class Array

  include DeferredExtensions
  
  #Format a 1D or 2D array into 'field[tab]field' lines.
  def to_string(separator = "\t")
    lines = Array.new
    each do |record|
      #Join fields with tabs, or just append record if no fields.
      lines << (record.respond_to?(:join) ? record.join(separator) : record)
    end
    lines.join("\n")
  end
  
end


class Integer

  include DeferredExtensions
  
end


class String

  include DeferredExtensions
  
  #Append a string to each line.
  def append(string)
    map{|line| line.chomp + string}.join("\n")
  end
  
  def decode_64
    require "base64"
    Base64.decode64(self)
  end

  def encode_64
    require "base64"
    Base64.encode64(self)
  end

  #Treats string as XML and indents it.
  def indent_xml
    string = ''
    to_xml_document.write(string, 0)
    string
  end
  
  #Interpolates string.
  #Pass in an optional hash to have its values available as "#{v[key]}".
  def interpolate(v = {})
    eval %Q{"#{gsub(/"/, '\"')}"}
  end

  #Split inline data into array of lines, interpolate, and remove leading space.
  def inline_data
    split(/\n/).map {|l| l.interpolate.sub(/^\s+/, '').chomp}
  end

  #Convert line separators within a string to spaces.
  def one_line
    gsub(/\n\s*/, '')
  end
  
  #Prepend a string on each line.
  def prepend(string)
    map{|line| string + line}
  end
  
  #Parse this string (with or without time) as a date and return it.
  def parse_date
    require 'date'
    require 'parsedate'
    elements = ParseDate.parsedate(self.to_s)
    DateTime.civil(elements[0], elements[1], elements[2], elements[3] || 0, elements[4] || 0, elements[5] || 0)
  end
  
  #Parses lines in "[key] [delimiter] [value]" format and returns as hash.
  def parse_config(delimiter = '=')
    values = {}
    each do |line|
      line.chomp!
      values[$1.downcase] = $2 if line =~ /^(.*?)\s*#{delimiter}\s*(.*)$/
    end
    values
  end

  #Returns header hash and body (as in an e-mail).
  def parse_headers(delimiter = ':')
    headers, body = split(/\n\n/, 2)
    [parse_config(delimiter), body]
  end
  
  #Evaluates as erb string, returning result.
  #If a hash is passed in, it will be available within the erb as "arg".
  def run_erb(arg = {})
    require 'erb'
    ERB.new(self.to_s, nil, '>').result(binding)
  end
  
  #Uses Windows Speech API to speak string.
  def speak
    require 'win32/sapi5'
    Win32::SpVoice.new.Speak(self.to_s)
  end
  
  #Convert a string of 'field[separator]field' lines into a 1D or 2D array.
  def to_array(separator = "\t")
    array = Array.new
    each do |line|
      line.chomp!
      if line.include?(separator)
        array << line.split(separator)
      else
        array << line
      end
    end
    array
  end

  #Treats string as path and opens it as a directory.
  #If block is given, yields opened directory to it, then closes directory.
  #If :create => true, create directory if it doesn't exist.
  #:permissions => 0xxx sets permissions of new directory if specified.
  def to_directory(options = {})
    if options[:create] and !File.exist?(self.to_s)
      Dir.mkdir(self.to_s, options[:permissions])
    end
    directory = Dir.new(self.to_s)
    if block_given?
      yield directory
      directory.close
    end
    directory
  end
  
  #Treats string as path and opens it with given mode.
  #If block is given, yields opened file to it, then closes file.
  def to_file(mode = "r")
    file = File.new(self.to_s, mode)
    if block_given?
      yield file
      file.close
    end
    file
  end
  
  #Treats string as YAML and converts to objects.
  def to_objects
    require 'yaml'
    YAML.load(self.to_s)
  end
  alias_method :deserialize, :to_objects
  
  #Treats string as URI and opens it.
  #Yields opened URI to block if given.
  def to_uri
    require 'open-uri'
    data = open(self.to_s)
    yield data if block_given?
    data
  end
  
  #Returns a REXML::Document representation.
  #Yields document if block given.
  def to_xml_document
    require 'rexml/document'
    xml = REXML::Document.new self.to_s
    yield xml if block_given?
    xml
  end
  
  #Splits on non-alphanumeric characters and returns array.
  def words
    self.split(/\W+/)
  end

  #Returns an abbreviation, useful for SMS.
  def shorthand
    abbreviation = self
    substitutions = {
      'probably' => 'prolly',
      'with' => 'w/',
      'you' => 'u',
      'love' => 'luv',
      'without' => 'w/out',
      'too' => '2',
      'to' => '2'
    }
    substitutions.each do |phrase, replacement|
      abbreviation.gsub!(/\b#{phrase}\b/i, replacement)
    end
    abbreviation
  end

end


class Time

  include DeferredExtensions
  
  #Returns a standard string format for a DateTime.
  def format
    sprintf("%04d-%02d-%02d_%02d%02d%02d", year, month, day, hour || 0, min || 0, sec || 0)
  end

  #Returns a standard string format for a Date.
  def format_date
    sprintf("%04d-%02d-%02d", year, month, day)
  end
  
end


class IO

  #Returns a REXML::Document representation.
  #Yields document if block given.
  def to_xml_document
    require 'rexml/document'
    xml = REXML::Document.new self
    yield xml if block_given?
    xml
  end
  
end


class File

  #Make a directory (along with any missing parents).
  def self.make_directory(path)
    require 'fileutils'
    FileUtils.mkdir_p(path)
  end

  #Get Time a file was last modified.
  def modified_time
    mtime
  end

  #Copy file to a given path.
  def copy(target)
    require 'fileutils'
    FileUtils.cp_r(path, target)
  end

  #Delete file/directory recursively.
  def delete
    require 'fileutils'
    FileUtils.rm_rf(path)
  end

  #Move file to a given path.
  def move(target)
    require 'fileutils'
    FileUtils.mv(path, target)
  end

  #Get EXIF original date for file.
  def exif_original_date
    EXIFR::JPEG.new(path).date_time_original
  end
  
end


class Dir
  
  alias old_each each
  
  #Like original each(), but skips '.' and '..'.
  def each
    old_each{|f| yield f unless f == '.' or f == '..'}
  end
  
  #Gives array of regular files within directory.
  def files
    find_all{|f| File.file?(f)}
  end
  
  #Gives array of subdirectories within directory.
  def subdirectories
    find_all{|f| File.directory?(f)}
  end
  
end


class Module
  
  private
    
    #Always call pre_method before wrapped_method.
    #Takes an optional hash with the following keys:
    #  :chain - if true, passes return value(s) of pre_method to wrapped_method.
    def before(wrapped_method, pre_method, options = {})
      module_eval <<-EOD
        alias_method :__#{wrapped_method.to_i}__, :#{wrapped_method.to_s}
        private :__#{wrapped_method.to_i}__
        def #{wrapped_method.to_s}(*args, &block)
          #{options[:chain] ? '' : "#{pre_method.to_s}(*args, &block)"}
          __#{wrapped_method.to_i}__(#{options[:chain] ? "#{pre_method.to_s}(*args, &block)" : '*args, &block'})
        end
      EOD
    end
  
    #Always call post_method after wrapped_method.
    #Takes an optional hash with the following keys:
    #  :chain - if true, passes return value(s) of wrapped_method to post_method.
    def after(wrapped_method, post_method, options = {})
      module_eval <<-EOD
        alias_method :__#{wrapped_method.to_i}__, :#{wrapped_method.to_s}
        private :__#{wrapped_method.to_i}__
        def #{wrapped_method.to_s}(*args, &block)
          #{options[:chain] ? '' : "__#{wrapped_method.to_i}__(*args, &block)"}
          #{post_method.to_s}(#{options[:chain] ? "__#{wrapped_method.to_i}__(*args, &block)" : '*args, &block'})
        end
      EOD
    end
  
end


require 'rexml/parent'
module REXML
  
  class Parent
    def each_xpath(*arguments, &block)
      require 'rexml/xpath'
      XPath.each(self, *arguments, &block)
    end
    def first_xpath(*arguments, &block)
      require 'rexml/xpath'
      XPath.first(self, *arguments, &block)
    end
    def match_xpath(*arguments)
      require 'rexml/xpath'
      XPath.match(self, *arguments)
    end
  end
  
end

  
module Kernel

  #Create temp file which will be automatically deleted when process terminates.
  def temp_file
    require 'tempfile'
    Tempfile.new("utility")
  end

  #Clipboard accessor.
  def clipboard
    require 'win32/clipboard'
    Win32::Clipboard.data.gsub(/\r\n/, "\n")
  end
  
  def set_clipboard(value)
    require 'win32/clipboard'
    Win32::Clipboard.set_data(value.to_s)
  end
  
end


module Enumerable

  #Surrounds elements with a character.
  def surround(mark = '"')
    map{|f| "#{mark}#{f}#{mark}"}
  end

end
