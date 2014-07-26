require 'singleton'
require 'irc-notify'

module Feedbook
  module Notifiers
    class IRCNotifier
      include Singleton

      # Sends notification to IRC
      # @param message [String] message to be send to IRC
      # 
      # @return [NilClass] nil
      def notify(message)
        client.register(nick)
        client.notify(message)
        client.quit
        
        puts "New message has been notified on IRC: #{message}"
      end

      # Load configuration for IRCNotifier
      # @param configuration = {} [Hash] Configuration hash (required: address, domain, username, password, to, from, subject)
      # 
      # @return [NilClass] nil
      def load_configuration(configuration = {})
        irc_url     = configuration.fetch('url')
        irc_port    = configuration.fetch('port')
        ssl_enabled = configuration.fetch('ssl_enabled')

        @channel = configuration.fetch('channel')
        @nick    = configuration.fetch('nick')
        
        @client = IrcNotify::Client.build(irc_url, irc_port, ssl: ssl_enabled)

        puts 'Configuration loaded for IRCNotifier'
      end

      private
      attr_reader :client, :nick, :channel
    end
  end
end