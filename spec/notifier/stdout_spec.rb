require 'spec_helper'
require 'spec_run_queue/notifier/stdout'

describe SpecRunQueue::Notifier::Stdout do
  before(:each) do
    @message = "spec message"
    @notifier = SpecRunQueue::Notifier::Stdout.new 
  end

  describe "notify" do

    it "should assign the message" do
      @notifier.notify(@message)
      @notifier.message.should == @message
    end

    it "should puts the message" do
      @notifier.should_receive(:puts).with(@message)
      @notifier.notify(@message)
    end
  end
end
