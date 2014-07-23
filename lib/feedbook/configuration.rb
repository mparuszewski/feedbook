require 'feedbook/notifiers'
require 'feedbook/helpers/time_interval_parser'

module Feedbook
  class Configuration
    attr_reader :interval

    INTERVAL_FORMAT = /\A(\d+)(s|m|h|d)\z/

    def initialize(opts = {})
      @interval    = Helpers::TimeIntervalParser.parse(opts.fetch(:interval, ''))
      @twitter     = opts.fetch(:twitter,  nil)
      @facebook    = opts.fetch(:facebook, nil)
      @irc         = opts.fetch(:irc, nil)
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

  end
end