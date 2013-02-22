# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spec_run_queue/version"

Gem::Specification.new do |s|
  s.name        = "spec_run_queue"
  s.version     = SpecRunQueue::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brendon Murphy"]
  s.email       = ["xternal1+github@gmail.com"]
  s.homepage    = "https://github.com/bemurphy/spec_run_queue"
  s.summary     = %q{Use a queue to run specs outside your editor}
  s.description = %q{Use a queue to run specs outside your editor}

  s.rubyforge_project = "spec_run_queue"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = ["redis_runner"]
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "redis"
  s.add_development_dependency "ruby-growl", '~> 3.0'
end
