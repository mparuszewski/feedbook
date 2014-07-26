module Feedbook
  module Errors
    class ParseFeedError < StandardError
      attr_reader :url
      def initialize(url, message)
        @url = url
        super(message)
      end
    end
  end
end