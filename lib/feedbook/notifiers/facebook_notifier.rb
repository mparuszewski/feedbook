require 'singleton'
require 'koala'

module Feedbook
  module Notifiers
    class FacebookNotifier
      include Singleton

      def notify(message)
        client.put_wall_post(message)
        puts "New message has been notified on Twitter: #{message}"
      end

      def load_configuration(configuration = {})
        @client = Koala::Facebook::API.new(configuration.fetch('token'))
      end

      private
      attr_reader :client
    end
  end
end