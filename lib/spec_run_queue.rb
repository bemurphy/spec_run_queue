require 'rubygems'
require 'redis'
require 'yaml'
require 'ruby-growl'

module SpecRunQueue
end

require 'spec_run_queue/queue/base'
require 'spec_run_queue/notifier/base'
require 'spec_run_queue/system_runner'