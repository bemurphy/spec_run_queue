require 'spec_helper'
require 'spec_run_queue/notifier/growl'

describe SpecRunQueue::Notifier::Growl do
  before(:each) do
    @message = "13 examples, 0 failures"
    @fail_message = "12 examples, 1 failure"
    @growl_mock = mock("Growl", :notify => true)
    @notifier = SpecRunQueue::Notifier::Growl.new(:password => "secret")
    @notifier.stub!(:growl).and_return(@growl_mock)
  end

  describe "notify" do
    it "should assign the message" do
      @notifier.notify(@message)
      @notifier.message.should == @message
    end

    context "with a failure message" do
      it "should send growl the expected message" do
        @growl_mock.should_receive(:notify).with('rspec-growl Notification', 'rspec-growl', '1 failure', 1)
        @notifier.notify(@fail_message)
      end
    end

    context "with a passing message" do
      it "should send growl the expected message" do
        @growl_mock.should_receive(:notify).with('rspec-growl Notification', 'rspec-growl', 'specs passed', -2)
        @notifier.notify(@message)
      end
    end

    context "when instruction to use the full message" do
      it "should send growl the full message" do
        @growl_mock.should_receive(:notify).with('rspec-growl Notification', 'rspec-growl', 'the full message', 1)
        @notifier.notify("the full message", :use_full_message => true)
      end
    end
  end
end
