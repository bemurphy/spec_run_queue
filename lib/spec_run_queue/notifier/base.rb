module SpecRunQueue
  module Notifier
    class Base
      attr_reader :config, :message

      def initialize(config = {})
        @config = config
      end    

      def notify(message, options = {})
        @message = message
      end

      private

      def failed?
        message !~ /\s+0\s+failure/
      end
    end
  end
end
