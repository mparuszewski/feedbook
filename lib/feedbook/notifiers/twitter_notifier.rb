require 'singleton'
require 'twitter'

module Feedbook
  module Notifiers
    class TwitterNotifier
      include Singleton

      def notify(message)
        client.update(message)
        puts "New message has been notified on Facebook: #{message}"
      end

      def load_configuration(configuration = {})
        @client = Twitter::REST::Client.new do |config|
          config.consumer_key        = configuration.fetch('consumer_key')
          config.consumer_secret     = configuration.fetch('consumer_secret')
          config.access_token        = configuration.fetch('access_token')
          config.access_token_secret = configuration.fetch('access_token_secret')
        end
      end

      private
      attr_reader :client
    end
  end
end