require 'spec_helper'
require 'spec_run_queue/queue/redis'

describe SpecRunQueue::Queue::Redis do
  before(:each) do
    @redis_mock = mock("Redis", :del => true, :blpop => true)
    ::Redis.stub!(:new).and_return(@redis_mock)
    @runner_mock = mock("Runner")
    @redis_queue = SpecRunQueue::Queue::Redis.new(@runner_mock)
  end

  it "should have 'rspec' as the key" do
    SpecRunQueue::Queue::Redis.queue_key.should == "rspec"
  end

  it "should reset the queue by deleting the queue key" do
    @redis_mock.should_receive(:del).with("rspec")
    SpecRunQueue::Queue::Redis.new(@runner_mock)
  end

  it "should blpop instructions off the redis queue" do
    @redis_mock.should_receive(:blpop).with("rspec", 0).and_return(nil)
    @redis_queue.run
  end
end
