require 'singleton'
require 'mail'

module Feedbook
  module Notifiers
    class MailNotifier
      include Singleton

      # Sends notification to Mail
      # @param message [String] message to be send via email
      # 
      # @return [NilClass] nil
      def notify(message)
        Mail.deliver do
          to      to
          from    from
          subject subject
          body    message
        end

        puts "New message has been notified on Mail: #{message}"
      end

      # Load configuration for MailNotifier
      # @param configuration = {} [Hash] Configuration hash (required: address, domain, username, password, to, from, subject)
      # 
      # @return [NilClass] nil
      def load_configuration(configuration = {})
        options = { address:              configuration.fetch('address'),
                    port:                 configuration.fetch('port', 5870),
                    domain:               configuration.fetch('domain'),
                    user_name:            configuration.fetch('username'),
                    password:             configuration.fetch('password'),
                    authentication:       configuration.fetch('authentication', 'plain'),
                    enable_starttls_auto: configuration.fetch('enable_starttls_auto', true)  }

        @to      = configuration.fetch('to')
        @from    = configuration.fetch('from')
        @subject = configuration.fetch('subject')

        Mail.defaults do
          delivery_method :smtp, options
        end

        puts 'Configuration loaded for MailNotifier'
      end

      private
      attr_reader :to, :from, :subject
    end
  end
end