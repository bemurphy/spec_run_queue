module SpecRunQueue
  module Queue
    class Base
      attr_reader :runner

      def initialize(runner)
        @runner = runner
        connect
        reset_queue
      end

      def run
        with_reconnect do
          while (raw_instruction = queue_fetch)
            instruction = YAML.load(raw_instruction[1])
            runner.run_spec(instruction)
          end
        end
      end

      def self.run_rescue_exceptions
        []
      end

      private

      def with_reconnect
        begin
          yield
        # rescue *self.class.run_rescue_exceptions => e
        rescue => e
          $stderr.puts "exception #{e.class} occurred, reconnecting..."
          sleep(1)
          connect
          retry
        end
      end

      def connect
        raise "Abstract method"
      end

      def reset_queue
        raise "Abstract method"
      end

      def queue_fetch
        raise "Abstract method"
      end
    end
  end
end

