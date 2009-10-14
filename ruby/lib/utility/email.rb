require 'utility/storage'
require 'utility/logging'
require 'utility/enhancements'


module Utility


module Email


  include Storage
  

  class Email

    include Storage
    include Logging
    
    attr_accessor :message_id
    attr_accessor :senders
    attr_accessor :recipients
    attr_accessor :cc_recipients
    attr_accessor :bcc_recipients
    attr_accessor :subject
    attr_accessor :body
    attr_accessor :date
    #Takes a hash with the following keys and defaults:
    # :message_id => nil,
    # :senders => [],
    # :recipients => [],
    # :cc_recipients => [],
    # :bcc_recipients => [],
    # :subject => "",
    # :body => "",
    # :date => nil
    def initialize(options = {})
      options = {
        :message_id => nil,
        :senders => [],
        :recipients => [],
        :cc_recipients => [],
        :bcc_recipients => [],
        :subject => "",
        :body => "",
        :date => nil
      }.merge(options)
      self.message_id = options[:message_id]
      self.senders = options[:senders]
      self.recipients = options[:recipients]
      self.cc_recipients = options[:cc_recipients]
      self.bcc_recipients = options[:bcc_recipients]
      self.subject = options[:subject]
      self.body = options[:body]
      self.date = options[:date]
    end
    
    #Sends an email.
    def send(options = {})
      require 'net/smtp'
      options = {
        :server => load(:smtp_server),
        :port => load(:smtp_port) || 25,
        :sender_domain => load(:smtp_sender_domain) || 'localhost.localdomain',
        :user_name => load(:smtp_user_name),
        :password => load(:smtp_password),
        :enable_tls => load(:smtp_enable_tls),
        :authentication_type => load(:smtp_authentication_type)
      }.merge(options)
      options[:authentication_type] ||= (options[:user_name] ? :login : nil)
      log.info self
      log.info options.merge({:password => '****'}).to_s
      if options[:enable_tls]
        require 'tlsmail'
        Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
      end
      Net::SMTP::start(
        options[:server], 
        options[:port], 
        options[:sender_domain], 
        options[:user_name], 
        options[:password],
        options[:authentication_type]
      ) do |smtp|
        smtp.send_message(
          "To: #{recipients.join(',')}\nSubject: #{subject}\n\n#{body}\n",
          senders.first,
          recipients
        )
      end
    end
    
  end


  #Parse string with e-mail headers and body and return E-mail object.
  def parse_rfc822(string)
    require 'utility/enhancements'
    headers, body = string.parse_headers
    log.debug "headers: #{headers}, body: #{body}"
    Email.new(
      :senders => headers['from'] ? headers['from'].split(/[;,]/) : [],
      :recipients => headers['to'] ? headers['to'].split(/[;,]/) : [],
      :cc_recipients => headers['cc'] ? headers['cc'].split(/[;,]/) : [],
      :bcc_recipients => headers['bcc'] ? headers['bcc'].split(/[;,]/) : [],
      :subject => headers['subject'] || '',
      :body => body
    )
  end


  def get_email(options = {})
    options = {
      :server => load(:imap_server),
      :login => load(:imap_password),
      :password => load(:ldap_password),
    }.merge(options)
    log.debug Utility.hash_to_s(options)
    #TODO: Restore!
  #   get_imap_email(options)
  end

  def get_imap_email(options = {})
    require 'net/imap'
    options = {
      :mailbox => "Inbox",
      :get_bodies => true,
    }.merge(options)
    log.debug Utility.hash_to_s(options)
    log.debug "Connect to server."
    server = Net::IMAP.new(options[:server])
    log.debug "Log in."
    server.login(options[:login], options[:password])
    log.debug "Get messages."
    server.examine(options[:mailbox])
    message_count = server.responses["EXISTS"][-1]
    emails = []
    (1..message_count).each do |message_id|
      email = Email.new
      envelope = server.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      envelope.from.each {|sender| email.senders << "#{sender.mailbox}@#{sender.host}"} if envelope.from
      envelope.to.each {|recipient| email.recipients << "#{recipient.mailbox}@#{recipient.host}"} if envelope.to
      envelope.cc.each {|recipient| email.cc_recipients << "#{recipient.mailbox}@#{recipient.host}"} if envelope.cc
      envelope.bcc.each {|recipient| email.bcc_recipients << "#{recipient.mailbox}@#{recipient.host}"} if envelope.bcc
      email.date = envelope.date
      email.subject = envelope.subject
      email.message_id = envelope.message_id
      if options[:get_bodies]
        email.body = server.fetch(message_id, "RFC822.TEXT")[0].attr["RFC822.TEXT"]
      end
      emails << email
    end
    emails
  end


end


end #module Utility
