require 'singleton'
require 'irc-notify'

module Feedbook
  module Notifiers
    class IRCNotifier
      include Singleton

      def notify(message)
        client.register(nick)
        client.notify(message)
        client.quit
        
        puts "New message has been notified on IRC: #{message}"
      end

      def load_configuration(configuration = {})
        irc_url     = configuration.fetch('url')
        irc_port    = configuration.fetch('port')
        ssl_enabled = configuration.fetch('ssl_enabled')

        @channel = configuration.fetch('channel')
        @nick    = configuration.fetch('nick')
        
        @client = IrcNotify::Client.build(irc_url, irc_port, ssl: ssl_enabled)
      end

      private
      attr_reader :client, :nick, :channel
    end
  end
end