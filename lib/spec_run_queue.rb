require 'rubygems'
require 'yaml'

module SpecRunQueue
  class Configuration
    attr_accessor :rspec_bin, :rspec_format

    def add_notifier(runner_symbol, options = {})
      klass = SpecRunQueue::Notifier.send(:const_get, runner_symbol.to_s.capitalize)
      SpecRunQueue.runner.add_notifier klass.new(options)
    end

    def to_h
      h = {}
      h[:rspec_bin]    = rspec_bin if rspec_bin
      h[:rspec_format] = rspec_format if rspec_format
      h
    end
  end

  def self.configuration
    @configuration || configure
  end

  def self.configure
    @configuration = Configuration.new

    if block_given?
      yield configuration
    end

    @configuration
  end

  def self.runner
    @runner ||= SystemRunner.new(configuration.to_h)
  end
end

require 'spec_run_queue/queue/base'
require 'spec_run_queue/notifier/base'
require 'spec_run_queue/system_runner'

module SpecRunQueue
  module Notifier
    autoload :Growl, 'spec_run_queue/notifier/growl'
    autoload :Stdout, 'spec_run_queue/notifier/stdout'
  end
end
