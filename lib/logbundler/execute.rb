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

    def make_temp_path(file)
      # TODO: make directories necessary to write file
    end

    # Convert time like "10s" to numeric seconds
    TIME_RE = Regexp.new('\s*(\d+)\s*([sSmMhH])?')
    def time_to_secs(time)
      return time if time.nil? or time.is_a?(Numeric)

      secs = nil
      if (match = TIME_RE.match(time))
        secs = match[1].to_i
        units = (match[2] || 's').downcase
        if units == 'm'
          secs = secs * 60
        elsif units == 'h'
          secs = secs * 3600
        end
      end
      secs
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
          shell_opts['cwd'] ||= @tmpdir
          shell_opts['timeout'] = time_to_secs(shell_opts['timeout'])
          (shell_opts['env'] ||= { })['TMPDIR'] = @tmpdir

          cmdline = entity['shell']
          %w(stdout stderr).each do |out|
            next unless entity[out] and not entity[out].empty?
            make_temp_path(entity[out])
            fd = (out == 'stderr') ? 1 : 2
            cmdline += " #{fd}> #{entity[out]}"
          end

          cmd = Mixlib::ShellOut.new(cmdline, shell_opts)
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
