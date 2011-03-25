require 'spec_helper'

class FooNotifier < SpecRunQueue::Notifier::Base
  def notify(message, options = {})
    super
    some_callout unless failed?
  end

  def some_callout
  end
end

describe "Base" do
  let(:notifier) { @notifier ||= FooNotifier.new() }

  before(:each) do
    @foo_notifier = FooNotifier.new
  end
  
  it "should store the config" do
    config = { :foo => :bar }
    notifier = FooNotifier.new(config)
    notifier.config.should == config
  end

  it "should be considered failed if the message doesn't match '0 failure'" do
    notifier.should_not_receive(:some_callout)
    notifier.notify('13 examples, 2 failures')
  end

  it "should not be consider failed if the message doesn't match '0 failure'" do
    notifier.should_receive(:some_callout)
    notifier.notify('13 examples, 0 failures')
  end

  describe "notify" do
    it "should assign the message" do
      message = '13 examples, 0 failures'
      notifier.notify(message)
      notifier.message.should == message
    end
  end
end
