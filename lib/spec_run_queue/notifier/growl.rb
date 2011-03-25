module SpecRunQueue
  module Notifier
    class Growl < Base
      def notify(message, options = {})
        super
        message = options[:use_full_message] ? message : short_message
        growl.notify "rspec-growl Notification", "rspec-growl", message, priority
      end

      private

      def priority
        failed? ? fail_priority : pass_priority
      end

      def fail_priority
        config[:fail_priority] || 1
      end

      def pass_priority
        config[:pass_priority] || -2 
      end

      def growl
        @growl ||= Growl.new "127.0.0.1", "rspec-growl", ["rspec-growl Notification"], nil, config[:password]
      end

      def short_message
        if message =~ /0 failure/
          "specs passed"
        elsif message =~ /(\d+\s+failures?)/
          $1
        end
      end
    end
  end
end
