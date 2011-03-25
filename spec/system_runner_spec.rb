require 'spec_helper'

describe SpecRunQueue::SystemRunner do
  let(:foo_notifier) { @foo_notifier ||= mock("FooNotifier", :notify => true) }
  let(:bar_notifier) { @bar_notifier ||= mock("BarNotifier", :notify => true) }
  let(:runner) { @runner ||= 
    begin
      runner = SpecRunQueue::SystemRunner.new(1)
      runner.add_notifier(foo_notifier)
      runner.add_notifier(bar_notifier)
      runner 
    end
  }

  describe "initializing" do
    it "should set the version" do
      runner = SpecRunQueue::SystemRunner.new(1, { :password => "foo" })
      runner.version.should == 1
    end

    it "should set the options" do
      runner = SpecRunQueue::SystemRunner.new(1, { :password => "foo" })
      runner.options.should == { :password => "foo" }
    end
  end
  
  describe "getting the rspec binary" do
    it "for version 1 is spec by default" do
      runner = SpecRunQueue::SystemRunner.new(1)
      runner.rspec_bin.should == "spec"
    end

    it "for varsion 2 is rspec by default" do
      runner = SpecRunQueue::SystemRunner.new(2)
      runner.rspec_bin.should == "rspec"
    end
  end

  describe "adding a notifier" do
    it "should append the notifier onto the notifiers list" do
      runner = SpecRunQueue::SystemRunner.new(1)
      foo_notifier = mock("FooNotifier")
      runner.add_notifier(foo_notifier)
      bar_notifier = mock("BarNotifier")
      runner.add_notifier(bar_notifier)
      runner.notifiers.should == [foo_notifier, bar_notifier]
    end
  end

  describe "running a spec" do
    it "should not run a spec if it's not a safe target" do
      runner.should_not_receive(:run_cmd)
      runner.run_spec(:target => "ls /tmp")
      runner.run_spec(:target => "ls /tmp;foo_spec.rb")
    end

    it "should not run a spec if the target doesn't end in _spec.rb" do
      runner.should_not_receive(:run_cmd)
      runner.run_spec(:target => "spec/foo.rb")
    end

    it "should not run a spec if the line number doesn't look like a number" do
      runner.should_not_receive(:run_cmd)
      runner.run_spec(:target => "foo_spec.rb", :line => "foo")
    end

    it "should call to run the spec" do
      runner.should_receive(:run_cmd).with("spec -f progress --drb foo_spec.rb")
      runner.run_spec(:target => "foo_spec.rb")
    end

    it "should send the output from the run to all the notifiers" do
      runner.should_receive(:run_cmd).with("spec -f progress --drb foo_spec.rb").and_return("spec output")
      foo_notifier.should_receive(:notify).with("spec output", {})
      bar_notifier.should_receive(:notify).with("spec output", {})
      runner.run_spec(:target => "foo_spec.rb")
    end

    context "with a line number" do
     it "should call to run the spec using the -l flag" do
      runner.should_receive(:run_cmd).with("spec -f progress --drb -l 42 foo_spec.rb")
      runner.run_spec(:target => "foo_spec.rb", :line => 42)
     end
    end
  end
end
