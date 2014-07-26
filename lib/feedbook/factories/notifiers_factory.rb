require 'feedbook/notifiers'
require 'feedbook/errors/unsupported_notifier_error'

module Feedbook
  module Factories
    class NotifiersFactory

      # Returns instance of Notifier for given type.
      # @param type [Symbol/String] name of requested notifier
      # 
      # @return [Notifier] Notifier instance
      def self.create(type)
        case type
        when :null, 'null'
          Notifiers::NullNotifier.instance
        when :twitter, 'twitter'
          Notifiers::TwitterNotifier.instance
        when :facebook, 'facebook'
          Notifiers::FacebookNotifier.instance
        when :irc, 'irc'
          Notifiers::IRCNotifier.instance
        else
          raise Errors::UnsupportedNotifierError.new(type)
        end
      end
    end
  end
end