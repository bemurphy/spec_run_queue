module SpecRunQueue
  module Notifier
    class Stdout < Base
      def notify(message, options = {})
        super
        puts message
      end
    end
  end
end
