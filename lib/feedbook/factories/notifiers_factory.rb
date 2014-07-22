require 'feedbook/notifiers'
require 'feedbook/errors/unsupported_notifier_error'

module Feedbook
  module Factories
    class NotifiersFactory

      def self.create(type)
        case type
        when :null, 'null'
          Notifiers::NullNotifier.instance
        when :twitter, 'twitter'
          Notifiers::TwitterNotifier.instance
        when :facebook, 'facebook'
          Notifiers::FacebookNotifier.instance
        else
          raise Errors::UnsupportedNotifierError.new 
        end
      end
    end
  end
end