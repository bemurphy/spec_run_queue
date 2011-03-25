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
        while (raw_instruction = queue_fetch)
          instruction = YAML.load(raw_instruction[1])
          runner.run_spec(instruction)
        end
      end

      private

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

