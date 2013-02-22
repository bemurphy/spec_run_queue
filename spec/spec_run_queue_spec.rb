require 'spec_helper'

describe SpecRunQueue, "default runner" do
  it "is a SystemRunner" do
    runner = stub(:runner)
    SpecRunQueue::SystemRunner.stub(:new).and_return(runner)
    SpecRunQueue.runner.should == runner
  end
end

describe SpecRunQueue, "Configuration" do
  before do
    SpecRunQueue.configure do |c|
      c.rspec_bin      = "/usr/local/bin/spec"
    end
  end

  it "provides a block style config" do
    SpecRunQueue.configuration.rspec_bin.should == "/usr/local/bin/spec"
  end

  it "can be converted to a hash of options" do
    SpecRunQueue.configuration.to_h.should == { :rspec_bin => "/usr/local/bin/spec" }
  end

  it "can add a notifier" do
    notifier = stub(:notifier)
    SpecRunQueue::Notifier::Growl.should_receive(:new).with(:password => "gpass").and_return(notifier)
    SpecRunQueue.runner.should_receive(:add_notifier).with(notifier)

    SpecRunQueue.configure do |c|
      c.add_notifier :growl, :password => "gpass"
    end
  end
end
