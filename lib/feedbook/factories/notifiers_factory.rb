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
        when :mail, 'mail'
          Notifiers::MailNotifier.instance
        else
          if Notifiers.const_defined?("#{type.capitalize}Notifier")
            Notifiers.const_get("#{type.capitalize}Notifier").instance
          elsif Notifiers.const_defined?("#{type.upcase}Notifier")
            Notifiers.const_get("#{type.upcase}Notifier").instance
          else
            puts "notifier #{type} is not supported by Feedbook."
          end
        end
      end
    end
  end
end