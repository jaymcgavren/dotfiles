require 'utility/logging'
require 'utility/storage'



module Utility


module Main

  include Logging
  include Storage

  #Print method list.
  def help
    self.methods
  end

  #Read STDIN, or ignore it if program is not being piped to.
  def get_piped_data
    STDIN.isatty ? nil : STDIN.read
  end

  #Send me an alert.
  def alert(data)
    log.info("*ALERT: " + data.to_s)
    begin
      send_to_phone(data)
    rescue
      display_message(data)
      raise
    end
  end

  #E-mail alert to cell phone
  def send_to_phone(data)
    require 'utility/email'
    subject_prefix = "Alert: "
    subject_string = data.to_s[0, 255 - subject_prefix.length]
    subject_string.gsub!(/\n/, " ")
    Utility::Email::Email.new(
      :senders => [load(:home_email)],
      :recipients => [load(:phone_email), load(:home_email)],
      :subject => subject_prefix + subject_string,
      :body => data.to_s
    ).send
  end

  #Display a message in a window.
  def display_message(message)
    require 'Win32API'
    require 'win32ole'
    WIN32OLE.new('WScript.Shell').Popup(message.to_s)
  end


  #Run external command with arguments.
  def run(command, *arguments)
    if arguments.empty?
      command_line = command
    else
      command_line = "#{command} #{arguments.join(' ')}"
    end
    log.debug "Running command: #{command_line}"
    output = `#{command_line}`
    fail "Error #{$?} executing '#{command_line}': #{output}" unless $? == 0
    log.debug "Got output: #{output}"
    output
  end


  #Retrieves resource at :url, follows links recursively, and saves to files.
  def store_url(options = {})
    options = {
      :base_directory => '.'
    }.merge(options)
    run(%W{
      wget
      --recursive
      --html-extension
      --convert-links
      --execute=robots=off
      --wait=60
      --random-wait
      #{"--user-agent=Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.12) Gecko/20080201 Firefox/2.0.0.12"}
      #{"--directory-prefix=" + options[:base_directory]}
      #{(options[:url] =~ %r{//([\w\.]+)}) ? "--domains=#{$1}" : ''}
      #{options[:url]}
    }.join(' '))
  end


  #Creates path for a file.
  #If creator, album, title, and sort order are provided, uses that information for sorting.
  #Returns assigned path.
  def make_path(options = {})
    path_components = []
    path_components << options[:base_directory]
    path_components << options[:creator] if options[:creator]
    path_components << Utility.format_date(options[:date]) if options[:date]
    path_components << options[:album] if options[:album]
    file_name_components = []
    file_name_components << (options[:sort_order] ? sprintf("%02d", options[:sort_order]): nil)
    file_name_components << options[:title]
    file_name = file_name_components.compact.join(' ')
    file_name += ".#{options[:extension]}" if options[:extension]
    path = File.join(path_components.compact)
    require 'fileutils'
    FileUtils.mkdir_p(path)
    full_path = File.join(path, file_name)
    log.debug "Path is #{full_path}."
    full_path
  end


  #Get a Windows registry key.
  def get_registry_key(name)
    require 'win32/registry'
    hkey, subkey_name = self.parse_registry_key_name(name)
    hkey.open(subkey_name) do |node|
      type, value = node.read('')
      return value
    end
  end
  #Set a Windows registry key.
  def set_registry_key(name, value, type_name = 'REG_SZ')
    require 'win32/registry'
    case type_name
    when 'REG_SZ'
      type = Win32::Registry::REG_SZ
    when 'REG_EXPAND_SZ'
      type = Win32::Registry::REG_EXPAND_SZ
    when 'REG_BINARY'
      type = Win32::Registry::REG_BINARY
    when 'REG_DWORD'
      type = Win32::Registry::REG_DWORD
    else
      raise "Cannot parse type '#{type}'."
    end
    hkey, subkey_name = self.parse_registry_key_name(name)
    hkey.open(subkey_name, Win32::Registry::KEY_WRITE) do |node|
      node.write('', type, value)
    end
  end
  def parse_registry_key_name(name) #:nodoc:
    require 'win32/registry'
    hkey_name, subkey_name = name.split(/\\/, 2)
    case hkey_name
    when 'HKEY_CLASSES_ROOT'
      hkey = Win32::Registry::HKEY_CLASSES_ROOT
    when 'HKEY_CURRENT_USER'
      hkey = Win32::Registry::HKEY_CURRENT_USER
    when 'HKEY_LOCAL_MACHINE'
      hkey = Win32::Registry::HKEY_LOCAL_MACHINE
    when 'HKEY_USERS'
      hkey = Win32::Registry::HKEY_USERS
    else
      raise "Cannot find HKEY '#{hkey_name}'."
    end
    return hkey, subkey_name
  end


end


end #module Utility
