require 'feedbook/notifiers'
require 'feedbook/helpers/time_interval_parser'

module Feedbook
  class Configuration
    attr_reader :interval

    INTERVAL_FORMAT = /\A(\d+)(s|m|h|d)\z/

    # Initializes new Configuration object with configuration for program instance
    # @param opts = {} [Hash] Hash with configuration of interval and suppliers
    # 
    # @return [NilClass] nil
    def initialize(opts = {})
      @interval    = Helpers::TimeIntervalParser.parse(opts.fetch(:interval, ''))
      @twitter     = opts.fetch(:twitter,  nil)
      @facebook    = opts.fetch(:facebook, nil)
      @irc         = opts.fetch(:irc, nil)
      @mail        = opts.fetch(:mail, nil)
    end

    # Load notifiers configuration
    # 
    # @return [NilClass] nil
    def load_notifiers
      unless twitter.nil?
        Notifiers::TwitterNotifier.instance.load_configuration(twitter)
      end
      
      unless facebook.nil?
        Notifiers::FacebookNotifier.instance.load_configuration(facebook)
      end

      unless irc.nil?
        Notifiers::IRCNotifier.instance.load_configuration(irc)
      end

      unless mail.nil?
        Notifiers::MailNotifier.instance.load_configuration(mail)
      end
    end

    private
    attr_reader :twitter, :facebook, :irc, :mail

  end
end