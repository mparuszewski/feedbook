require 'singleton'

module Feedbook
  module Notifiers
    class NullNotifier
      include Singleton

      # Sends notification to Nil
      # @param message [String] message to be displayed in console
      # 
      # @return [NilClass] nil
      def notify(message)
        puts "New message has been notified: #{message}"
      end
      
      # Load configuration for NullNotifier
      # @param configuration = {} [Hash] Configuration hash
      # 
      # @return [NilClass] nil
      def load_configuration(_)
        puts 'Configuration loaded for NullNotifier'
      end
    end
  end
end