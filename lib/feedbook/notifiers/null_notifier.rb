require 'singleton'

module Feedbook
  module Notifiers
    class NullNotifier
      include Singleton

      def notify(message)
        puts "New message has been notified: #{message}"
      end
      
      def load_configuration(configuration = {})
      end
    end
  end
end