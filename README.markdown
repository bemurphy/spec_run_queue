WHAT
====

spec_run_queue lets you build a lightweight queue watcher to watch for commands to run specs for your project.

On projects with a slow test suite, I don't like waiting for an autotest-like setup to complete a full spec run of a file.  Also, I don't like watching my editor lock up waiting for a spec run to finish.

My development flow on such files tends to be 1) write a new spec example 2) run a focused example 3) repeat a few times 4) run the full spec

The runner works by doing a blocking queue read, until it receives a YAML dump of a hash like

    { :target => "spec/models/foo_spec.rb"  }

or

    { :target => "spec/models/bar_spec.rb", :line => 42 }

and then runs the command, via backticks, in the shell.  Summary results from the run are sent to the Notifier#notify method for notifiers you have setup.

NOTIFIERS
=========

Notifiers must provide at least one instance method, <tt>notify</tt>, which processes the output from the spec run.  Currently, there are two runners, Stdout, and Growl.  Stdout prints the results from the run to the terminal window, while growl sends a brief pass/fail summary to growl.


CONFIGURATION
=============

You can configure per project behavior by creating a SpecRunQueueFile in the root of
your project.  An example of such a file might look like:

```ruby
SpecRunQueue.configure do |c|
  c.rspec_bin = "bundle exec rspec"
  c.add_notifier :growl, :password => "fizzbuzz"
end
```

If you do not provide a configuration, the runner will assume a binary of `rspec` and
use the stdout notifier.

USAGE
=====

In your project root, run

    redis_runner

In order to trigger a queue run, you need your editor to insert a YAML dump of the instructions described above to the queue.

TODO
====

* Include code or a plugin for the vim script I'm using to inject instructions into the queue
* Investigate a custom rspec runner in place of the current shell execution method
* Swap YAML for JSON
