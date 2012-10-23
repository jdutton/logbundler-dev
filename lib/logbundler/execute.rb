require 'tmpdir'
require 'mixlib/shellout'

class Logbundler
  class Execute
    attr_reader :tmpdir
    attr_reader :status

    def initialize
      @status = { }
    end

    # Create a temporary directory, but make sure we clean it up at exit time
    def make_tmpdir
      unless @tmpdir
        @tmpdir = Dir.tmpdir
        at_exit { FileUtils.rm_rf(@tmpdir) }
      end
      @tmpdir
    end

    def execute(config)
      make_tmpdir
      config.each do |entity|
        if entity['shell']
          shell_opts = { }

          # Directly pass the following options from the config to the command obj
          props = %w(cwd user group umask timeout input env)
          props.each do |prop|
            shell_opts[prop] = entity[prop] unless entity[prop].nil?
          end
          cmd = Mixlib::ShellOut.new(entity['shell'], shell_opts)
          begin
            cmd.run_command
            Logbundler.log("#{entity['shell']} command exited after #{cmd.execution_time} with #{cmd.status} status")
            %w(stdout stderr).each { |out| Logbundler.log("#{entity['shell']} #{out}: #{cmd.send(out)}") }
          rescue Errno::ENOENT => err
            Logbundler.log("#{entity['shell']} command not found")
          rescue Errno::EACCES => err
            Logbundler.log("#{entity['shell']} permission denied")
          rescue Mixlib::ShellOut::CommandTimeout => err
            Logbundler.log("#{entity['shell']} timed out")
          rescue Exception => err
            Logbundler.log("Unknown exception running command #{entity['shell']} - #{err.class} -> #{err}")
          end
        end
      end
    end
  end
end
