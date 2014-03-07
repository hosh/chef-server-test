require 'mixlib/shellout'

BASE_DIR = File.absolute_path(File.join(File.dirname(__FILE__), '..', '..'))
SHELLOUT_DEFAULTS = { cwd: BASE_DIR }

module ChefServerTest
  module ShellOut
    def chef_client(recipes)
      cmd = shell_out "chef-client #{ChefServerTest::Config.chef_client_flags} -o #{recipes}"
      return if cmd.status.success?
      $stderr.print "ERROR: #{cmd.exitstatus}\nSTDERR:\n #{cmd.stderr}\n"
      $stderr.print "Failure."
      cmd
    end

    def shell_out(cmd, options = {})
      options = SHELLOUT_DEFAULTS.merge(timeout: 3600).merge(options)
      cmd = Mixlib::ShellOut.new(cmd, options)
      cmd.live_stream = STDOUT
      cmd.run_command
    end

    def shell_out!(cmd, options = {})
      cmd = run_command(cmd, options)
      return if cmd.status.success?
      $stderr.print "ERROR: #{cmd.exitstatus}\nSTDOUT:\n#{cmd.stdout}\n\nSTDERR:\n#{cmd.stderr}\n"
      exit 1
    end
  end
end
