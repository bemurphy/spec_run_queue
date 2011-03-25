require 'redis'

module SpecRunQueue
  module Queue
    class Redis < Base
      attr_reader :redis

      def self.queue_key
        "rspec" 
      end

      private

      def connect
        @redis = ::Redis.new
      end

      def reset_queue
        redis.del self.class.queue_key
      end

      def queue_fetch
        redis.blpop self.class.queue_key, 0 
      end
    end
  end
end
