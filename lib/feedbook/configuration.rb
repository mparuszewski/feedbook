require 'feedbook/factories/notifiers_factory'
require 'feedbook/helpers/time_interval_parser'

module Feedbook
  class Configuration
    attr_reader :interval, :options

    INTERVAL_FORMAT = /\A(\d+)(s|m|h|d)\z/

    # Initializes new Configuration object with configuration for program instance
    # @param opts = {} [Hash] Hash with configuration of interval and suppliers
    # 
    # @return [NilClass] nil
    def initialize(opts = {})
      @interval    = Helpers::TimeIntervalParser.parse opts.delete('interval')
      @options     = opts
    end

    # Load notifiers configuration
    # 
    # @return [NilClass] nil
    def load_notifiers
      options.each do |name, config|
        notifier = Factories::NotifiersFactory.create(name)
        notifier.load_configuration(config) unless notifier.nil?
      end
    end
  end
end