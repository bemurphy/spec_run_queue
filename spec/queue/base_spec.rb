require "spec_helper"

class SpecBase < SpecRunQueue::Queue::Base
  attr_accessor :connect_called, :reset_queue_called

  def connect
    self.connect_called = true
  end

  def reset_queue
    self.reset_queue_called = true
  end
end

describe "Base" do
  let(:runner) { @runner ||= mock("Runner", :run_spec => true) }
  let(:spec_base) { @spec_base ||= SpecBase.new(runner) }

  describe "initilization" do
    it "should set the runner" do
      spec_base.runner.should == runner
    end

    it "should call to connect" do
      spec_base.connect_called.should be_true
    end

    it "should reset the queue" do
      spec_base.reset_queue_called.should be_true
    end
  end

  describe "running of the queue" do
    before(:each) do
      @first_raw_instruction = YAML.dump({ :target => "foo_spec.rb" })
      @second_raw_instruction = YAML.dump({ :target => "bar_spec.rb", :line => 42 })
    end

    it "should fetch raw instructions from the queue" do
      spec_base.should_receive(:queue_fetch).and_return(nil)
      spec_base.run
    end

    it "should parse each raw instruction as yaml" do
      spec_base.stub!(:queue_fetch).and_return(["rspec", @first_raw_instruction], ["rspec", @second_raw_instruction], nil)
      YAML.should_receive(:load).with(@first_raw_instruction).ordered
      YAML.should_receive(:load).with(@second_raw_instruction).ordered
      spec_base.run
    end

    it "should pass the parsed instruction to runner.run_spec" do
      spec_base.stub!(:queue_fetch).and_return(["rspec", @first_raw_instruction], ["rspec", @second_raw_instruction], nil)
      runner.should_receive(:run_spec).with({ :target => "foo_spec.rb" }).ordered
      runner.should_receive(:run_spec).with({ :target => "bar_spec.rb", :line => 42 }).ordered
      spec_base.run
    end
  end
end

