WIP

WHAT
====

spec_run_queue lets you build a lightweight queue watcher to watch for commands to run specs for your project.

On projects with a slow test suite, I don't like waiting for an autotest-like setup to complete a full spec run of a file.  My development flow on such files tends to be 1) write a new spec 2) run a focused spec 3) repeat a few times 4) run the full spec

The runner works by doing a blocking queue read, until it receives a YAML dump of a hash like

    { :target => "spec/models/foo_spec.rb"  }

or

    { :target => "spec/models/bar_spec.rb", :line => 42 }

and then runs the command, via backticks, in the shell.  Summary results from the run are sent to the Notifier#notify method for notifiers you have setup.
