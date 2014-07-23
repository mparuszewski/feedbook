require 'timeloop'
require 'feedbook/errors/invalid_interval_format_error'

module Feedbook
  module Helpers
    class TimeIntervalParser

      INTERVAL_FORMAT = /\A(\d+)(s|m|h|d)\z/
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