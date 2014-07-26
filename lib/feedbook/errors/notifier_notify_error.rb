module Feedbook
  module Errors
    class NotifierNotifyError < StandardError
      attr_reader :notifier

      def initialize(notifier, message = {})
        @notifier = notifier
        super(message)
      end
    end
  end
end