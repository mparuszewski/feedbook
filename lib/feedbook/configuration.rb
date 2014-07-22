require 'timeloop/core_ext'
require 'feedbook/notifiers'
require 'feedbook/errors/invalid_interval_format_error'

module Feedbook
  class Configuration
    attr_reader :interval

    INTERVAL_FORMAT = /\A(\d+)(s|m|h|d)\z/

    def initialize(opts = {})
      @interval    = read_interval(opts.fetch(:interval, ''))
      @twitter     = opts.fetch(:twitter,  {})
      @facebook    = opts.fetch(:facebook, {})
      @irc         = opts.fetch(:irc, {})
    end

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
    end

    private
    attr_reader :twitter, :facebook, :irc

    def read_interval(value)
      if value.strip =~ INTERVAL_FORMAT
        number, type = INTERVAL_FORMAT.match(value).captures
        case type
        when 's'
          Integer(number).seconds
        when 'm'
          Integer(number).minutes
        when 'h'
          Integer(number).hours
        when 'd'
          Integer(number).days
        end
      else
        raise Errors::InvalidIntervalFormatError.new
      end
    end

  end
end