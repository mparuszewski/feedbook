require 'timeloop'
require 'feedbook/errors/invalid_interval_format_error'

module Feedbook
  module Helpers
    class TimeIntervalParser

      INTERVAL_FORMAT = /\A(\d+)(s|m|h|d)\z/

      # Parses given string with interval and converts into a amount of seconds.
      # @param value [String] String with interval (e.g. '10m', '100s', '20h', '10d')
      # 
      # @return [Integer] amount of seconds that equals given interval value 
      # @raise [Feedbook::Errors::InvalidIntervalFormatError] if given string is not a valid format
      def self.parse(value)
        if value.strip =~ INTERVAL_FORMAT
          number, type = INTERVAL_FORMAT.match(value).captures
          case type
          when 's'
            Integer(number).seconds
          when 'm'
            Integer(number).minutes
          when 'h'
            Integer(number).hours
          when 'd'
            Integer(number).days
          end
        else
          raise ArgmumentError.new
        end

      rescue
        raise Errors::InvalidIntervalFormatError.new
      end

    end
  end
end