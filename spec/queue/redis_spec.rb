require 'spec_helper'
require 'spec_run_queue/queue/redis'

describe SpecRunQueue::Queue::Redis do
  before(:each) do
    Dir.stub!(:pwd).and_return("/tmp")
    @queue_key = "spec_run_queue:d42b9c57d24cf5db3bd8d332dc35437f" # /tmp hashed
    @redis_mock = mock("Redis", :del => true, :blpop => true)
    ::Redis.stub!(:new).and_return(@redis_mock)
    @runner_mock = mock("Runner")
    @redis_queue = SpecRunQueue::Queue::Redis.new(@runner_mock)
  end

  it "should have 'spec_run_queue:<md5string>' as the key" do
    SpecRunQueue::Queue::Redis.queue_key.should == @queue_key
  end

  it "should reset the queue by deleting the queue key" do
    @redis_mock.should_receive(:del).with(@queue_key)
    SpecRunQueue::Queue::Redis.new(@runner_mock)
  end

  it "should blpop instructions off the redis queue" do
    @redis_mock.should_receive(:blpop).with(@queue_key, 0).and_return(nil)
    @redis_queue.run
  end
end
