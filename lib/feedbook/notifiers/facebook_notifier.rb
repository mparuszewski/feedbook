require 'singleton'
require 'koala'
require 'feedbook/errors/notifier_configuration_error'
require 'feedbook/errors/notifier_notify_error'

module Feedbook
  module Notifiers
    class FacebookNotifier
      include Singleton

      # Sends notification to Facebook wall
      # @param message [String] message to be send to Facebook wall
      # 
      # @return [NilClass] nil
      # @raise [Feedbook::Errors::NotifierNotifyError] if notify method fails 
      def notify(message)
        if client.nil?
          puts "Message has not been notified on Facebook: #{message} because of invalid client configuration"
        else
          client.put_wall_post(message)
          puts "New message has been notified on Facebook: #{message}"
        end
      rescue Koala::KoalaError => e
        raise Errors::NotifierNotifyError.new(:facebook, e.message)
      end

      # Load configuration for FacebookNotifier
      # @param configuration = {} [Hash] Configuration hash (required: token)
      # 
      # @return [NilClass] nil
      # @raise [Feedbook::Errors::NotifierConfigurationError] if notifier configuration fails 
      def load_configuration(configuration = {})
        @client = Koala::Facebook::API.new(configuration.fetch('token'))
        
        puts 'Configuration loaded for FacebookNotifier'
      rescue Koala::KoalaError => e
        raise Errors::NotifierConfigurationError.new(:facebook, e.message)
      end

      private
      attr_reader :client
    end
  end
end