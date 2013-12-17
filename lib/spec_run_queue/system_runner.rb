module SpecRunQueue
  class SystemRunner
    attr_reader :options, :notifiers

    def initialize(options = {})
      @options = options
      @notifiers = []
    end

    def rspec_bin
      options.fetch(:rspec_bin, "rspec")
    end

    def add_notifier(notifier)
      @notifiers << notifier
    end

    def run_spec(instruction)
      unless sane_instruction?(instruction)
        $stderr.puts "Insane instruction #{instruction.inspect}"
        return
      end

      begin
        cmd = "#{rspec_bin} -f nested --drb"
        cmd << " -l#{instruction[:line]}" if instruction[:line]
        cmd << " #{instruction[:target]}"
        puts "Running command #{cmd}"
        output = run_cmd(cmd)

        output_to_notifiers(output)
      rescue => e
        shutdown_message = "Exception #{e.class} occurred, shutting down"
        output_to_notifiers(shutdown_message, :use_full_message => true)
        sleep(1)
        raise e
      end
    end

    private

    def run_cmd(cmd)
      specs = IO.popen cmd
      output = ""
      while line = specs.gets
        output += line
        puts line
      end

      specs.close

      output
    end

    def output_to_notifiers(output, options = {})
      notifiers.each do |notifier|
        notifier.notify(output, options)
      end
    end

    def sane_instruction?(instruction)
      # Line must be numeric or nil, and the target must be a path to a spec file
      (instruction[:line].nil? || instruction[:line].to_s =~ /\A\d+\z/) &&
        (instruction[:target] =~ /\A[a-z0-9_\-\/]+_spec\.rb\z/)
    end
  end
end
